{stdenv, fetchurl, ghc}:

stdenv.mkDerivation (rec {

  pname = "binary";
  version = "0.4.1";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "bb74824306843da25f6d97c271e2a06ee3a7e05fc529156fb81d7c576688e549";
  };

  buildInputs = [ghc];

  meta = {
    description = "Efficient, pure binary serialisation using lazy ByteStrings";
  };

  configurePhase = ''
    ghc --make Setup.lhs
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
