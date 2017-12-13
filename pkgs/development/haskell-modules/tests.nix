{ ghcWithPackages
, ghcWithHoogle
, stdenv
, ghc
, pkgs
}:

let
  ghcWithPackagesTest = ghcWithPackages (ps: [ps.conduit]);
  ghcWithHoogleTest = ghcWithHoogle (ps: [ps.conduit]);
  ghcWithConduit = pkgs.writeText "ghc-with-conduit.hs" ''
    import Data.Conduit
    import Control.Monad.RWS

    main = undefined
  '';
in stdenv.mkDerivation {
  name = "tests-for-${ghc.name}";

  buildCommand = ''
    echo "running tests..."

    echo "assert Data.Conduit page is generated"
    test -e ${ghcWithHoogleTest}/share/doc/html/Data-Conduit.html
  
    echo "assert conduit dependency mtl is generated"
    test -e ${ghcWithHoogleTest}/share/doc/html/Control-Monad-RWS.html

    ${ghcWithPackagesTest}/bin/ghc -o Foo ${ghcWithConduit}

    echo "done!"
    mkdir $out
    touch $out/success
  '';
 
  meta.platforms = stdenv.lib.platforms.all;
}
