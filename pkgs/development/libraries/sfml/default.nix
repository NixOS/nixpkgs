{ stdenv, fetchzip, cmake, libX11, freetype, libjpeg, openal, flac, libvorbis
, glew, libXrandr, libXrender, udev, xcbutilimage
, cf-private, IOKit, Foundation, AppKit, OpenAL
}:

let
  version = "2.5.1";
in

stdenv.mkDerivation rec {
  name = "sfml-${version}";

  src = fetchzip {
    url = "https://github.com/SFML/SFML/archive/${version}.tar.gz";
    sha256 = "0abr8ri2ssfy9ylpgjrr43m6rhrjy03wbj9bn509zqymifvq5pay";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freetype libjpeg openal flac libvorbis glew ]
    ++ stdenv.lib.optional stdenv.isLinux udev
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 libXrandr libXrender xcbutilimage ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit Foundation AppKit OpenAL
    # Needed for _NSDefaultRunLoopMode, _OBJC_CLASS_$_NSArray, _OBJC_CLASS_$_NSDate
    cf-private
    ];

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
