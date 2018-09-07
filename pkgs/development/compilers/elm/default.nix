{ lib, stdenv, buildEnv, haskell, nodejs, fetchurl, makeWrapper, git }:

# To update:

# 1) Modify ./update.sh and run it

# 2) to generate versions.dat:
# 2.1) git clone https://github.com/elm/compiler.git
# 2.2) cd compiler
# 2.3) cabal2nix --shell . | sed 's/"default",/"ghc822",/' > shell.nix
# 2.4) nix-shell
# 2.5) mkdir .elm
# 2.6) export ELM_HOME=$(pwd)/.elm
# 2.7) cabal build
# 2.8) cp .elm/0.19.0/package/versions.dat ...

# 3) generate a template for elm-elm.nix with:
# (
#   echo "{";
#   jq '.dependencies | .direct, .indirect | to_entries | .[] | { (.key) : { version : .value, sha256:  "" } } ' \
#   < ui/browser/elm.json \
#   | sed 's/:/ =/' \
#   | sed 's/^[{}]//' \
#   | sed -E 's/(["}]),?$/\1;/' \
#   | sed -E 's/"(version|sha256)"/\1/' \
#   | grep -v '^$';
#   echo "}"
# )
#
# ... then fill in the sha256s

# Notes:

# the elm binary embeds a piece of pre-compiled elm code, used by 'elm
# reactor'. this means that the build process for 'elm' effectively
# executes 'elm make'. that in turn expects to retrieve the elm
# dependencies of that code (elm/core, etc.) from
# package.elm-lang.org, as well as a cached bit of metadata
# (versions.dat).

# the makeDotElm function lets us retrieve these dependencies in the
# standard nix way. we have to copy them in (rather than symlink) and
# make them writable because the elm compiler writes other .dat files
# alongside the source code. versions.dat was produced during an
# impure build of this same code; the build complains that it can't
# update this cache, but continues past that warning.

# finally, we set ELM_HOME to point to these pre-fetched artifacts so
# that the default of ~/.elm isn't used.

let
  makeDotElm = ver: deps:
    let versionsDat = ./versions.dat;
        cmds = lib.mapAttrsToList (name: info: let
                 pkg = stdenv.mkDerivation {

                   name = lib.replaceChars ["/"] ["-"] name + "-${info.version}";

                   src = fetchurl {
                     url = "https://github.com/${name}/archive/${info.version}.tar.gz";
                     meta.homepage = "https://github.com/${name}/";
                     inherit (info) sha256;
                   };

                   phases = [ "unpackPhase" "installPhase" ];

                   installPhase = ''
                     mkdir -p $out
                     cp -r * $out
                   '';

                 };
               in ''
                 mkdir -p .elm/${ver}/package/${name}
                 cp -R ${pkg} .elm/${ver}/package/${name}/${info.version}
               '') deps;
    in (lib.concatStrings cmds) + ''
      mkdir -p .elm/${ver}/package;
      cp ${versionsDat} .elm/${ver}/package/versions.dat;
      chmod -R +w .elm
    '';

  hsPkgs = haskell.packages.ghc822.override {
    overrides = self: super: with haskell.lib;
      let elmPkgs = {
            elm = overrideCabal (self.callPackage ./packages/elm.nix { }) (drv: {
              # sadly with parallelism most of the time breaks compilation
              enableParallelBuilding = false;
              preConfigure = ''
                export ELM_HOME=`pwd`/.elm
              '' + (makeDotElm "0.19.0" (import ./packages/elm-elm.nix));
              buildTools = drv.buildTools or [] ++ [ makeWrapper ];
              postInstall = ''
                wrapProgram $out/bin/elm \
                  --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
              '';
            });



            /*
            This is not a core Elm package, and it's hosted on GitHub.
            To update, run:

                cabal2nix --jailbreak --revision refs/tags/foo http://github.com/avh4/elm-format > packages/elm-format.nix

            where foo is a tag for a new version, for example "0.8.0".
            */
            elm-format = overrideCabal (self.callPackage ./packages/elm-format.nix {  }) (drv: {
              # https://github.com/avh4/elm-format/issues/529
              patchPhase = ''
                cat >Setup.hs <<EOF
                import Distribution.Simple
                main = defaultMain
                EOF

                sed -i '/Build_elm_format/d' elm-format.cabal
                sed -i 's/Build_elm_format.gitDescribe/""/' src/ElmFormat/Version.hs
                sed -i '/Build_elm_format/d' src/ElmFormat/Version.hs
              '';
            });
          };
      in elmPkgs // {
        inherit elmPkgs;
        elmVersion = elmPkgs.elm.version;

        # Needed for elm-format
        indents = self.callPackage ./packages/indents.nix {};
      };
  };
in hsPkgs.elmPkgs
