{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, doxygen, mesa_noglu, glew
, xorg , ffmpeg, python3 , libjpeg, libpng, libtiff, eigen
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "pangolin-${version}";

  version = "2017-08-02";

  src = fetchFromGitHub {
    owner = "stevenlovegrove";
    repo = "Pangolin";
    rev = "f05a8cdc4f0e32cc1664a430f1f85e60e233c407";
    sha256 = "0pfbaarlsw7f7cmsppm7m13nz0k530wwwyczy2l9k448p3v7x9j0";
  };

  nativeBuildInputs = [ cmake pkgconfig doxygen ]; 

  buildInputs = [ 
    mesa_noglu 
    glew 
    xorg.libX11 
    ffmpeg 
    python3 
    libjpeg 
    libpng 
    libtiff 
    eigen 
  ]
  ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  enableParallelBuilding = true;

  # The tests use cmake's findPackage to find the installed version of
  # pangolin, which isn't what we want (or available).
  doCheck = false;
  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  meta = {
    description = "A lightweight portable rapid development library for managing OpenGL display / interaction and abstracting video input";
    longDescription = ''
      Pangolin is a lightweight portable rapid development library for managing
      OpenGL display / interaction and abstracting video input. At its heart is
      a simple OpenGl viewport manager which can help to modularise 3D
      visualisation without adding to its complexity, and offers an advanced
      but intuitive 3D navigation handler. Pangolin also provides a mechanism
      for manipulating program variables through config files and ui
      integration, and has a flexible real-time plotter for visualising
      graphical data.
    '';
    homepage = https://github.com/stevenlovegrove/Pangolin;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.expipiplus1 ];
    platforms = stdenv.lib.platforms.all;
  };
}
