{ stdenv, fetchurl, cmake, libX11, freetype, libjpeg, openal, libsndfile
, glew, libXrandr, libXrender, udev
}:
stdenv.mkDerivation rec {
  name = "sfml-2.2";
  src = fetchurl {
    url = "https://github.com/LaurentGomila/SFML/archive/2.2.tar.gz";
    sha256 = "1xbpzkqwgbsjdda7n3c2z5m16bhppz1z9rbhmhb8r1im7s95hd2l";
  };
  buildInputs = [ cmake libX11 freetype libjpeg openal libsndfile glew
                  libXrandr libXrender udev
                ];
  meta = with stdenv.lib; {
    homepage = http://www.sfml-dev.org/;
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.astsmtl ];
  };
}
