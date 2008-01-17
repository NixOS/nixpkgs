{stdenv, fetchurl, ghc, zlib}:

stdenv.mkDerivation (rec {

  pname = "zlib";
  version = "0.4.0.2";

  name = "${pname}-Haskell-${version}";

  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "e6e9e51ca5b7f1685eb031f826f7865acc10cc2c8d0dfad975e0e81fd17f17ed";
  };

  buildInputs = [ghc];

  propagatedBuildInputs = [zlib];

  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
  };

  extraLibDirs = "${zlib}/lib";

  configurePhase = ''
    sed -i '/extra-libraries/a\ \ \ \ extra-lib-dirs: ${extraLibDirs}' ${pname}.cabal
    ghc --make Setup.hs
    ./Setup configure --prefix="$out"
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
