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
#         extraPrefs = self: {
#           hoogleLocal = pkgs.haskellPackages.hoogleLocal.override {
#             packages = with pkgs.haskellPackages; [
#               mmorph
#               monadControl
#             ]
#           };
#         };
#       });
# }}
#
# This will build mmorph and monadControl, and have the hoogle installation
# refer to their documentation via symlink so they are not garbage collected.

{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, QuickCheck, random, resourcet, safe, shake, tagsoup, text
, time, transformers, uniplate, vector, vectorAlgorithms, wai, warp
, fetchurl

, parallel, perl, wget, rehoo, haskellPlatform
, packages ? haskellPlatform.propagatedUserEnvPkgs
}:

cabal.mkDerivation (self: rec {
  pname = "hoogle";
  version = "4.2.32";
  sha256 = "1rhr7xh4x9fgflcszbsl176r8jq6rm81bwzmbz73f3pa1zf1v0zc";
  isLibrary = true;
  isExecutable = true;
  buildInputs = [self.ghc Cabal] ++ self.extraBuildInputs
    ++ [ parallel perl wget rehoo ] ++ packages;
  buildDepends = [
      aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
      deepseq filepath haskellSrcExts httpTypes parsec QuickCheck random
      resourcet safe shake tagsoup text time transformers uniplate vector
      vectorAlgorithms wai warp
    ];
  testDepends = [ filepath ];
  testTarget = "--test-option=--no-net";

  # The tests will fail because of the added documentation.
  doCheck = false;
  patches = [ ./hoogle-local.diff
              (fetchurl { url = "https://github.com/ndmitchell/hoogle/commit/5fc294f2b5412fda107c7700f4d833b52f26184c.diff";
                          sha256 = "1fn52g90p2jsy87gf5rqrcg49s8hfwway5hi4v9i2rpg5mzxaq3i"; })
            ];

  docPackages = packages;

  postInstall = ''
    if [ -z "$docPackages" ]; then
        echo "ERROR: The packages attribute has not been set"
        exit 1
    fi

    ensureDir $out/share/hoogle/doc
    export HOOGLE_DOC_PATH=$out/share/hoogle/doc

    cd $out/share/hoogle

    function import_dbs() {
        find $1 -name '*.txt' \
            | parallel -j$NIX_BUILD_CORES 'cp -p {} .; perl -i -pe "print \"\@url file://{//}/index.html\n\" if /^\@version/;" {/}; $out/bin/hoogle convert {/}'
    }

    for i in $docPackages; do
        import_dbs $i/share/doc
        ln -sf $i/share/doc/*-ghc-*/* $out/share/hoogle/doc 2> /dev/null \
            || ln -sf $i/share/doc/* $out/share/hoogle/doc
    done

    import_dbs ${self.ghc}/share/doc/ghc*/html/libraries
    ln -sf ${self.ghc}/share/doc/ghc*/html/libraries/* $out/share/hoogle/doc

    unset http_proxy
    unset ftp_proxy

    chmod 644 *.hoo *.txt
    $out/bin/hoogle data -d $PWD --redownload -l $(echo *.txt | sed 's/\.txt//g')
    PATH=$out/bin:$PATH ${rehoo}/bin/rehoo -j4 -c64 .

    rm -fr downloads *.txt *.dep
    mv default.hoo x || exit 0
    rm -f *.hoo
    mv x default.hoo || exit 1

    if [ ! -f default.hoo ]; then
        echo "Unable to build the default Hoogle database"
        exit 1
    fi

    mv $out/bin/hoogle $out/bin/.hoogle-wrapped
    cat - > $out/bin/hoogle <<EOF
    #! ${self.stdenv.shell}
    COMMAND=\$1
    shift
    HOOGLE_DOC_PATH=$out/share/hoogle/doc exec $out/bin/.hoogle-wrapped \$COMMAND -d $out/share/hoogle "\$@"
    EOF
    chmod +x $out/bin/hoogle
  '';

  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.jwiegley ];
  };
})
