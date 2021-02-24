{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, sqlite, gmp, libffi, cairo,
  ncurses, freetype, libGLU, libGL, libpng, libtiff, libjpeg, readline, libsndfile,
  libxml2, freeglut, libsamplerate, pcre, libevent, libedit, yajl,
  python3, openssl, glfw, pkg-config, libpthreadstubs, libXdmcp, libmemcached
}:

stdenv.mkDerivation {
  name = "io-2015.11.11";
  src = fetchFromGitHub {
    owner = "stevedekorte";
    repo = "io";
    rev = "1fc725e0a8635e2679cbb20521f4334c25273caa";
    sha256 = "0ll2kd72zy8vf29sy0nnx3awk7nywpwpv21rvninjjaqkygrc0qw";
  };

  patches = [
    (fetchpatch {
      name = "check-for-sysctl-h.patch";
      url = "https://github.com/IoLanguage/io/pull/446/commits/9f3e4d87b6d4c1bf583134d55d1cf92d3464c49f.patch";
      sha256 = "9f06073ac17f26c2ef6298143bdd1babe7783c228f9667622aa6c91bb7ec7fa0";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib sqlite gmp libffi cairo ncurses freetype
    libGLU libGL libpng libtiff libjpeg readline libsndfile libxml2
    freeglut libsamplerate pcre libevent libedit yajl
    pkg-config glfw openssl libpthreadstubs libXdmcp
    libmemcached python3
  ];

  preConfigure = ''
    # The Addon generation (AsyncRequest and a others checked) seems to have
    # trouble with building on Virtual machines. Disabling them until it
    # can be fully investigated.
    sed -ie \
          "s/add_subdirectory(addons)/#add_subdirectory(addons)/g" \
          CMakeLists.txt
  '';

  # for gcc5; c11 inline semantics breaks the build
  NIX_CFLAGS_COMPILE = "-fgnu89-inline";

  meta = with lib; {
    description = "Io programming language";
    homepage = "http://iolanguage.org/";
    license = licenses.bsd3;

    maintainers = with maintainers; [
      raskin
      maggesi
      vrthra
    ];
    platforms = [ "x86_64-linux" ];
  };
}
