# Install not only the Hoogle library and executable, but also a local Hoogle
# database which provides "Source" links to all specified 'packages' -- or the
# current Haskell Platform if no custom package set is provided.
#
# It is intended to be used in config.nix similarly to:
#
# { packageOverrides = pkgs: rec {
#
#   haskellPackages =
#     let callPackage = pkgs.lib.callPackageWith haskellPackages;
#     in pkgs.recurseIntoAttrs (pkgs.haskellPackages.override {
#         extension = self: super: {
#           hoogleLocal = pkgs.haskellPackages.hoogleLocal.override {
#             packages = with pkgs.haskellPackages; [
#               mmorph
#               monadControl
#             ];
#           };
#         };
#       });
# }}
#
# This will build mmorph and monadControl, and have the hoogle installation
# refer to their documentation via symlink so they are not garbage collected.

{ lib, stdenv, hoogle, rehoo, writeText
, ghc, packages ? [ ghc.ghc ]
}:

let
  inherit (stdenv.lib) optional;
  wrapper = ./hoogle-local-wrapper.sh;
  isGhcjs = ghc.isGhcjs or false;
  opts = lib.optionalString;
  haddockExe =
    if !isGhcjs
    then "haddock"
    else "haddock-ghcjs";
  ghcName =
    if !isGhcjs
    then "ghc"
    else "ghcjs";
  docLibGlob =
    if !isGhcjs
    then ''share/doc/ghc*/html/libraries''
    else ''doc/lib'';
  # On GHCJS, use a stripped down version of GHC's prologue.txt
  prologue =
    if !isGhcjs
    then "${ghc}/${docLibGlob}/prologue.txt"
    else writeText "ghcjs-prologue.txt" ''
      This index includes documentation for many Haskell modules.
    '';
in
stdenv.mkDerivation {
  name = "hoogle-local-0.1";
  buildInputs = [hoogle rehoo];

  phases = [ "buildPhase" ];

  docPackages = (lib.closePropagation packages);

  buildPhase = ''
    if [ -z "$docPackages" ]; then
        echo "ERROR: The packages attribute has not been set"
        exit 1
    fi

    mkdir -p $out/share/doc/hoogle

    function import_dbs() {
        find $1 -name '*.txt' | while read f; do
          newname=$(basename "$f" | tr '[:upper:]' '[:lower:]')
          if [[ -f $f && ! -f ./$newname ]]; then
            cp -p $f "./$newname"
            hoogle convert -d "$(dirname $f)" "./$newname"
          fi
        done
    }

    echo importing builtin packages
    for docdir in ${ghc}/${docLibGlob}/*; do
      name="$(basename $docdir)"
      ${opts isGhcjs ''docdir="$docdir/html"''}
      if [[ -d $docdir ]]; then
        import_dbs $docdir
        ln -sfn $docdir $out/share/doc/hoogle/$name
      fi
    done

    echo importing other packages
    for i in $docPackages; do
      if [[ ! $i == $out ]]; then
        for docdir in $i/share/doc/*-${ghcName}-*/* $i/share/doc/*; do
          name=`basename $docdir`
          docdir=$docdir/html
          if [[ -d $docdir ]]; then
            import_dbs $docdir
            ln -sfn $docdir $out/share/doc/hoogle/$name
          fi
        done
      fi
    done

    echo building hoogle database
    # FIXME: rehoo is marked as depricated on Hackage
    chmod 644 *.hoo *.txt
    rehoo -j$NIX_BUILD_CORES -c64 .

    mv default.hoo .x
    rm -fr downloads *.dep *.txt *.hoo
    mv .x $out/share/doc/hoogle/default.hoo

    echo building haddock index
    # adapted from GHC's gen_contents_index
    cd $out/share/doc/hoogle

    args=
    for hdfile in `ls -1 */*.haddock | grep -v '/ghc\.haddock' | sort`
    do
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
    hydraPlatforms = with stdenv.lib.platforms; none;
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
