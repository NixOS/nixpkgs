# Install not only the Hoogle library and executable, but also a local Hoogle
# database which provides "Source" links to all specified 'packages' -- or the
# current Haskell Platform if no custom package set is provided.

{ lib, stdenv, buildPackages, haskellPackages
, writeText
}:

# This argument is a function which selects a list of Haskell packages from any
# passed Haskell package set.
#
# Example:
#   (hpkgs: [ hpkgs.mtl hpkgs.lens ])
selectPackages:

let
  inherit (haskellPackages) ghc hoogle;
  packages = selectPackages haskellPackages;

  wrapper = ./hoogle-local-wrapper.sh;
  isGhcjs = ghc.isGhcjs or false;
  opts = lib.optionalString;
  haddockExe =
    if !isGhcjs
    then "haddock"
    else "haddock-ghcjs";
  ghcDocLibDir =
    if !isGhcjs
    then ghc.doc + "/share/doc/ghc*/html/libraries"
    else ghc     + "/doc/lib";
  # On GHCJS, use a stripped down version of GHC's prologue.txt
  prologue =
    if !isGhcjs
    then "${ghcDocLibDir}/prologue.txt"
    else writeText "ghcjs-prologue.txt" ''
      This index includes documentation for many Haskell modules.
    '';

  # TODO: closePropagation is deprecated; replace
  docPackages = lib.closePropagation
    # we grab the doc outputs
    (map (lib.getOutput "doc") packages);

in
buildPackages.stdenv.mkDerivation {
  name = "hoogle-with-packages";
  buildInputs = [ghc hoogle];

  inherit docPackages;

  passAsFile = ["buildCommand"];

  buildCommand = ''
    ${let # Filter out nulls here to work around https://github.com/NixOS/nixpkgs/issues/82245
          # If we don't then grabbing `p.name` here will fail.
          packages' = lib.filter (p: p != null) packages;
      in lib.optionalString (packages' != [] -> docPackages == [])
       ("echo WARNING: localHoogle package list empty, even though"
       + " the following were specified: "
       + lib.concatMapStringsSep ", " (p: p.name) packages')}
    mkdir -p $out/share/doc/hoogle

    echo importing builtin packages
    for docdir in ${ghcDocLibDir}"/"*; do
      name="$(basename $docdir)"
      ${opts isGhcjs ''docdir="$docdir/html"''}
      if [[ -d $docdir ]]; then
        ln -sfn $docdir $out/share/doc/hoogle/$name
      fi
    done

    echo importing other packages
    ${lib.concatMapStringsSep "\n" (el: ''
        ln -sfn ${el.haddockDir} "$out/share/doc/hoogle/${el.name}"
      '')
      (lib.filter (el: el.haddockDir != null)
        (builtins.map (p: { haddockDir = if p ? haddockDir then p.haddockDir p else null;
                            name = p.pname; })
          docPackages))}

    echo building hoogle database
    hoogle generate --database $out/share/doc/hoogle/default.hoo --local=$out/share/doc/hoogle

    echo building haddock index
    # adapted from GHC's gen_contents_index
    cd $out/share/doc/hoogle

    args=
    for hdfile in $(ls -1 *"/"*.haddock | grep -v '/ghc\.haddock' | sort); do
        name_version=`echo "$hdfile" | sed 's#/.*##'`
        args="$args --read-interface=$name_version,$hdfile"
    done

    ${ghc}/bin/${haddockExe} --gen-index --gen-contents -o . \
         -t "Haskell Hierarchical Libraries" \
         -p ${prologue} \
         $args

    echo finishing up
    mkdir -p $out/bin
    substitute ${wrapper} $out/bin/hoogle \
        --subst-var out --subst-var-by shell ${stdenv.shell} \
        --subst-var-by hoogle ${hoogle}
    chmod +x $out/bin/hoogle
  '';

  passthru = {
    isHaskellLibrary = false; # for the filter in ./with-packages-wrapper.nix
  };

  meta = {
    description = "A local Hoogle database";
    platforms = ghc.meta.platforms;
    hydraPlatforms = with lib.platforms; none;
    maintainers = with lib.maintainers; [ ttuegel ];
  };
}
