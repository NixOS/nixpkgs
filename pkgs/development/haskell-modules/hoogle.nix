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

{ stdenv, hoogle, rehoo
, ghc, packages ? [ ghc.ghc ]
}:

let
  inherit (stdenv.lib) optional;
  wrapper = ./hoogle-local-wrapper.sh;
in
stdenv.mkDerivation {
  name = "hoogle-local-0.1";
  buildInputs = [hoogle rehoo];

  phases = [ "installPhase" ];

  docPackages = packages;
  installPhase = ''
    if [ -z "$docPackages" ]; then
        echo "ERROR: The packages attribute has not been set"
        exit 1
    fi

    mkdir -p $out/share/hoogle/doc
    export HOOGLE_DOC_PATH=$out/share/hoogle/doc

    cd $out/share/hoogle

    function import_dbs() {
        find $1 -name '*.txt' | while read f; do
          newname=$(basename "$f" | tr '[:upper:]' '[:lower:]')
          if [[ -f $f && ! -f ./$newname ]]; then
            cp -p $f ./$newname
            hoogle convert -d "$(dirname $f)" "./$newname"
          fi
        done
    }

    for i in $docPackages; do
        findInputs $i docPackages propagated-native-build-inputs
        findInputs $i docPackages propagated-build-inputs
    done

    for i in $docPackages; do
      if [[ ! $i == $out ]]; then
        for docdir in $i/share/doc/*-ghc-*/* $i/share/doc/*; do
          if [[ -d $docdir ]]; then
            import_dbs $docdir
            ln -sf $docdir $out/share/hoogle/doc
          fi
        done
      fi
    done

    import_dbs ${ghc}/share/doc/ghc*/html/libraries
    ln -sf ${ghc}/share/doc/ghc*/html/libraries/* $out/share/hoogle/doc

    chmod 644 *.hoo *.txt
    rehoo -j4 -c64 .

    rm -fr downloads *.dep *.txt
    mv default.hoo x || exit 0
    rm -f *.hoo
    mv x default.hoo || exit 1

    if [ ! -f default.hoo ]; then
        echo "Unable to build the default Hoogle database"
        exit 1
    fi

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
