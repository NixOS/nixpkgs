{stdenv, fetchurl, ghc}:

stdenv.mkDerivation (rec {

  pname = "vty";
  version = "3.0.0";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${name}.tar.gz";
    sha256 = "44ae53d06b8b45c14cd3861e860a38730ed9995ed56b1b3d9aba6641771f1947";
  };

  buildInputs = [ghc];

  meta = {
    description = "vty is a *very* simplistic library in the niche of ncurses";
  };

  configurePhase = ''
    sed -i 's|^Build-Depends:.*$|&, bytestring, containers|' ${pname}.cabal
    ghc --make Setup.lhs
    ./Setup configure -v --prefix="$out"
  '';

  buildPhase = ''
    ./Setup build
  '';

  installPhase = ''
    ./Setup copy
    ./Setup register --gen-script
    mkdir $out/nix-support
    sed -i 's/|.*\(ghc-pkg update\)/| \1/' register.sh
    cp register.sh $out/nix-support/register-ghclib.sh
    sed -i 's/\(ghc-pkg update\)/\1 --user/' register.sh
    mkdir $out/bin
    cp register.sh $out/bin/register-ghclib-${name}.sh
  '';

})
