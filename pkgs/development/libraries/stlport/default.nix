{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "STLport-5.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/stlport/${name}.tar.bz2";
    sha256 = "1jbgak1m1qk7d4gyn1p2grbws2icsf7grbs3dh44ai9ck1xh0nvm";
  };

  # fix hardcoded /usr/bin; not recognizing the standard --disable-static flag
  configurePhase = ''
    echo Preconf: build/Makefiles/gmake/*/sys.mak
    for f in build/Makefiles/gmake/*/sys.mak; do
      substituteInPlace "$f" --replace /usr/bin/ ""
    done
    ./configure --prefix=$out
  '';

  meta = {
    description = "An implementation of the C++ Standard Library";
    homepage = http://sourceforge.net/projects/stlport/;
    license = "free"; # seems BSD-like
  };
}
