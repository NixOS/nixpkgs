{ lib, stdenv, fetchzip, cmake, libX11, freetype, libjpeg, openal, flac, libvorbis
, glew, libXrandr, libXrender, udev, xcbutilimage
, IOKit, Foundation, AppKit, OpenAL
}:

stdenv.mkDerivation rec {
  pname = "sfml";
  version = "2.5.1";

  src = fetchzip {
    url = "https://github.com/SFML/SFML/archive/${version}.tar.gz";
    sha256 = "0abr8ri2ssfy9ylpgjrr43m6rhrjy03wbj9bn509zqymifvq5pay";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freetype libjpeg openal flac libvorbis glew ]
    ++ lib.optional stdenv.isLinux udev
    ++ lib.optionals (!stdenv.isDarwin) [ libX11 libXrandr libXrender xcbutilimage ]
    ++ lib.optionals stdenv.isDarwin [ IOKit Foundation AppKit OpenAL ];

  cmakeFlags = [ "-DSFML_INSTALL_PKGCONFIG_FILES=yes"
                 "-DSFML_MISC_INSTALL_PREFIX=share/SFML"
                 "-DSFML_BUILD_FRAMEWORKS=no"
                 "-DSFML_USE_SYSTEM_DEPS=yes" ];

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
