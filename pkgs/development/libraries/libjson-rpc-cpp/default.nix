{ stdenv, fetchFromGitHub, cmake, jsoncpp, argtable, curl, libmicrohttpd
, doxygen, catch, pkgconfig, git, gcc6
}:

stdenv.mkDerivation rec {
  name = "libjson-rpc-cpp-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cinemast";
    repo = "libjson-rpc-cpp";
    sha256 = "07bg4nyvx0yyhy8c4x9i22kwqpx5jlv36dvpabgbb46ayyndhr7a";
    rev = "v${version}";
  };

  NIX_CFLAGS_COMPILE = "-I${catch}/include/catch";

  postPatch = ''
    for f in cmake/FindArgtable.cmake \
             src/stubgenerator/stubgenerator.cpp \
             src/stubgenerator/stubgeneratorfactory.cpp
    do
      sed -i -re 's/argtable2/argtable3/g' $f
    done

    sed -i -re 's#MATCHES "jsoncpp"#MATCHES ".*/jsoncpp/json$"#g' cmake/FindJsoncpp.cmake
  '';

  configurePhase = ''
    mkdir -p Build/Install
    pushd Build

    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install \
             -DCMAKE_BUILD_TYPE=Release
  '';

  installPhase = '' 
    mkdir -p $out

    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      q="$p:${stdenv.lib.makeLibraryPath [ gcc6 jsoncpp argtable libmicrohttpd curl ]}:$out/lib"
      patchelf --set-rpath $q $1
    }

    make install

    sed -i -re "s#-([LI]).*/Build/Install(.*)#-\1$out\2#g" Install/lib/pkgconfig/*.pc
    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      fixRunPath $f
    done

    cp -r Install/* $out
  '';

  nativeBuildInputs = [ pkgconfig gcc6 ];
  buildInputs = [ cmake jsoncpp argtable curl libmicrohttpd doxygen catch ];

  meta = with stdenv.lib; {
    description = "C++ framework for json-rpc (json remote procedure call)";
    homepage = https://github.com/cinemast/libjson-rpc-cpp;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
