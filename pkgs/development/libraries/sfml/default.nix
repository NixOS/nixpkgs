{ stdenv, fetchurl, cmake, libX11, freetype, libjpeg, openal, flac, libvorbis
, glew, libXrandr, libXrender, udev, xcbutilimage
, IOKit, Foundation, AppKit, OpenAL
}:

let
  version = "2.5.0";
in

stdenv.mkDerivation rec {
  name = "sfml-${version}";
  src = fetchurl {
    url = "https://github.com/SFML/SFML/archive/${version}.tar.gz";
    sha256 = "1x3yvhdrln5b6h4g5r4mds76gq8zsxw6icxqpwqkmxsqcq5yviab";
  };
  buildInputs = [ cmake libX11 freetype libjpeg openal flac libvorbis glew
                  libXrandr libXrender xcbutilimage
                ] ++ stdenv.lib.optional stdenv.isLinux udev
                  ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit Foundation AppKit OpenAL ];
  cmakeFlags = [ "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
                 "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
                 "-DSFML_BUILD_FRAMEWORKS=no"
                 "-DSFML_USE_SYSTEM_DEPS=yes" ];
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
    platforms = platforms.unix;
  };
}
