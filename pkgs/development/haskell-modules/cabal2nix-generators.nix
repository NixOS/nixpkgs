{ pkgs, stdenv, all-cabal-hashes, callPackage, self, overrideCabal }:

let
  all-cabal-hashes-component = name: version: pkgs.runCommand "all-cabal-hashes-component-${name}-${version}" {} ''
    tar --wildcards -xzvf ${all-cabal-hashes} \*/${name}/${version}/${name}.{json,cabal}
    mkdir -p $out
    mv */${name}/${version}/${name}.{json,cabal} $out
  '';
in {
  # Runs cabal2nix on a cabal file for a Hackage package. This
  # function will try to find the best way to get the cabal file for
  # this package depending on the parameters given. If revision and
  # revisionSha256 are specified, it will use that cabal file. If a
  # sha256 is supplied, it will use the package's release tarball to
  # find the cabal file. Otherwise, it will lookup the package in
  # all-cabal-hashes and use the cabal file found there.
  #
  # As consequences, this means that supplying a sha256 but no
  # revision will use the 0th revision, and supplying neither a
  # revision nor a sha256 will use whatever revision happens to be in
  # all-cabal-hashes.
  #
  # When sha256 is specified, all-cabal-hashes isn't needed to find
  # the tarball's hash, so it is avoided for the cabal file as
  # well. Although this does mean that the revision is potentially
  # older, it also means that package versions that haven't been
  # checked into nixpkgs's version of all-cabal-hashes yet are
  # available.
  #
  # Note: Unfortunately, cabal2nix can't be instructed to emit a
  # chosen revision number and hash, so specifying a reivion is only
  # useful for helping cabal2nix spit out the correct list of
  # dependencies, in case a revision helps with that. The revision
  # does get properly set in genericCallCabal2nix, though.
  genericHackage2nix =
    { pname
    , version ? null
    , sha256 ? null
    , revision ? null
    , revisionSha256 ? null
    , extraCabal2nixOptions ? ""
    }:
    let
      pkgver = "${pname}-${version}";

      component = all-cabal-hashes-component pname version;

      realSha256 =
        if sha256 != null
        then sha256
        else (builtins.fromJSON (builtins.readFile "${component}/${pname}.json")).package-hashes.SHA256;

      revisionCabal =
        assert (stdenv.lib.assertMsg (revisionSha256 != null) "Setting revision requires setting revisionSha256.");
        pkgs.fetchurl {
          url = "http://hackage.haskell.org/package/${pkgver}/revision/${revision}.cabal";
          sha256 = revisionSha256;
        };

      # By using the same sha256 that will be passed to
      # generic-builder, we guarantee that at least this is not an
      # extraneous derivation.
      tarball = pkgs.fetchurl {
        url = "mirror://hackage/package/${pkgver}/${pkgver}.tar.gz";
        inherit sha256;
      };
      tarballCabal =
        if sha256 == null
        # If the user is not supplying a hash, we are relying on
        # all-cabal-hashes anyway. Might as well use it for the
        # cabal file to potentially get a newer revision, and to
        # avoid creating another extraneous derivation.
        then component
        # If we do need to fetch the cabal file, use the source
        # tarball, as we can't infer a newer revision.
        else pkgs.runCommand "${pkgver}-cabal" {} ''
          mkdir -p $out
          tar -xOzf ${tarball} ${pkgver}/${pname}.cabal > $out/${pname}.cabal
        '';

      cabalFile = if revision != null then revisionCabal else "${tarballCabal}/${pname}.cabal";
    in self.haskellSrc2nix {
      name = pname;
      inherit extraCabal2nixOptions;
      src = cabalFile;
      sha256 = realSha256;
    };

  # Convenience wrapper around genericHackage2nix. Always gets
  # information from all-cabal-hashes.
  hackage2nix = pname: version:
    self.genericHackage2nix { inherit pname version; };

  # Runs cabal2nix on a package's cabal file, and uses
  # import-from-derivation to call the resulting expression.
  #
  # If src is specified, the cabal file in that directory is used. If
  # src is filterable with cleanSourceWith, it is filtered down to
  # just the cabal file to ensure the entire src isn't copied into the
  # Nix store on every eval.
  #
  # If no src is specified, the remaining parameters are delegated to
  # genericHackage2nix to get the cabal file from Hackage.
  #
  # In both cases, the Nix expression is called with callPackage. The
  # returned derivation is modified slightly with overrideCabal before
  # being returned by genericCallCabal2nix.
  #
  # If src is specified, it is re-set in the overrideCabal, so that if
  # the src was filtered for its cabal file, the full src is used for
  # building the package.
  #
  # The derivation yielding the Nix expression is made a build-time
  # dependency, so that garbage collecting with 'keep-outputs = true'
  # will not collect the Nix expression. This derivation is also made
  # available as the cabal2nixDeriver attr.
  #
  # Finally, if a revision is specified, then genericHackage2nix will
  # use that to get the right cabal file from Hackage, but it won't be
  # used during building. Therefore the revision and editedCabalFile
  # arguments are modified accordingly by genericCallCabal2nix to use
  # the right revision.
  genericCallCabal2nix =
    { pname
    , version ? null
    , src ? null
    , sha256 ? null
    , revision ? null
    , revisionSha256 ? null
    , extraCabal2nixOptions ? ""
    }@settings:
    args:
    let
      filter = path: type:
        stdenv.lib.hasSuffix "${pname}.cabal" path ||
        baseNameOf path == "package.yaml";
      expr =
        if src == null
        then self.genericHackage2nix (builtins.removeAttrs settings ["src"])
        else self.haskellSrc2nix {
          name = pname;
          inherit extraCabal2nixOptions;
          src =
            if stdenv.lib.canCleanSource src
            then stdenv.lib.cleanSourceWith { inherit src filter; }
            else src;
        };
    in overrideCabal (callPackage expr args) (old: {
      preConfigure = ''
        # Generated from ${expr}
        ${old.preConfigure or ""}
      '';
      passthru = old.passthru or {} // { cabal2nixDeriver = expr; };
    } // stdenv.lib.optionalAttrs (src != null) {
      # In case we filtered down to metadata files. Also, make sure
      # not to set `src = null` so that src can be pulled
      # automatically from Hackage in generic-builder.
      inherit src;
    } // stdenv.lib.optionalAttrs (revision != null) {
      inherit revision;
      editedCabalFile = revisionSha256;
    });

  # This function does not depend on all-cabal-hashes and therefore will work
  # for any version that has been released on hackage as opposed to only
  # versions released before whatever version of all-cabal-hashes you happen
  # to be currently using.
  callHackageDirect = {pkg, ver, sha256}:
    self.genericCallCabal2nix { pname = pkg; version = ver; inherit sha256; };

  callHackage = pname: version:
    self.genericCallCabal2nix { inherit pname version; };

  # Creates a Haskell package from a source package by calling cabal2nix on the source.
  callCabal2nixWithOptions = pname: src: extraCabal2nixOptions:
    self.genericCallCabal2nix { inherit pname src extraCabal2nixOptions; };

  callCabal2nix = pname: src: args: self.callCabal2nixWithOptions pname src "" args;
}
