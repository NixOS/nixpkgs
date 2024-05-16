{ lib
, stdenv
, fetchFromGitHub
, cmake
, libX11
, freetype
, libjpeg
, openal
, flac
, libvorbis
, glew
, libXrandr
, libXrender
, udev
, xcbutilimage
, IOKit
, Foundation
, AppKit
, OpenAL
, libXcursor
}:

stdenv.mkDerivation rec {
  pname = "sfml";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    rev = version;
    hash = "sha256-R+ULgaKSPadcPNW4D2/jlxMKHc1L9e4FprgqLRuyZk4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freetype libjpeg openal flac libvorbis glew ]
    ++ lib.optional stdenv.hostPlatform.isLinux udev
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ libX11 libXrandr libXrender xcbutilimage  libXcursor ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ IOKit Foundation AppKit OpenAL ];

  cmakeFlags = [
    "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
    "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
    "-DSFML_BUILD_FRAMEWORKS=no"
    "-DSFML_USE_SYSTEM_DEPS=yes"
    "-DSFML_PKGCONFIG_INSTALL_PREFIX=share/pkgconfig"
  ];

  meta = with lib; {
    homepage = "https://www.sfml-dev.org/";
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
