{ stdenv, fetchurl, cmake, libX11, freetype, libjpeg, openal, flac, libvorbis
, glew, libXrandr, libXrender, udev, xcbutilimage
}:

let
  version = "2.4.1";
in

stdenv.mkDerivation rec {
  name = "sfml-${version}";
  src = fetchurl {
    url = "https://github.com/LaurentGomila/SFML/archive/${version}.tar.gz";
    sha256 = "13irazmqk9vcgkigsjcxns7xjmnz1gifw0b656z1rpz208diklgr";
  };
  buildInputs = [ cmake libX11 freetype libjpeg openal flac libvorbis glew
                  libXrandr libXrender udev xcbutilimage
                ];
  cmakeFlags = [ "-DSFML_INSTALL_PKGCONFIG_FILES=yes" ];
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
    platforms = platforms.linux;
  };
}
