{stdenv, fetchurl, ghc, libX11, xineramaSupport ? true, libXinerama ? null, libXext ? null}:

assert xineramaSupport -> (libXinerama != null && libXext != null);

stdenv.mkDerivation (rec {

  pname = "X11";
  version = "1.4.1";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://hackage.haskell.org/packages/archive/${pname}/${version}/${name}.tar.gz";
    sha256 = "e51038541415686f0e278ccdbc0b2373cd11f212de99023b7b8f8e776aa09f79";
  };

  buildInputs = [ghc];

  propagatedBuildInputs = [libX11] ++
    (if xineramaSupport then [libXinerama libXext] else []);

  meta = {
    description = "A Haskell binding to the X11 graphics library";
  };

  extraLibDirs = "${libX11}/lib" + (if xineramaSupport then " ${libXinerama}/lib ${libXext}/lib" else "");

  configurePhase = ''
    echo "extra-lib-dirs: ${extraLibDirs}" >> X11.buildinfo.in
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
