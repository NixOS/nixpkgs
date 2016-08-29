{ stdenv
, fetchgit
, cmake
, jsoncpp
, argtable
, curl
, libmicrohttpd
, doxygen
, catch
}:
stdenv.mkDerivation rec {
  name = "libjson-rpc-cpp-${version}";
  version = "0.6.0";

  src = fetchgit {
    url = https://github.com/cinemast/libjson-rpc-cpp.git;
    sha256 = "00fxxisg89zgg1wq047n8r8ws48jx35x3s6bbym4kg7dkxv9vv9f";
    rev = "c6e3d7195060774bf95afc6df9c9588922076d3e";
  };

  hardeningDisable = [ "format" ];

  patchPhase = ''
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
      q="$p:${stdenv.lib.makeLibraryPath [ stdenv.cc.cc jsoncpp argtable libmicrohttpd curl ]}:$out/lib"
      patchelf --set-rpath $q $1
    }

    make install

    sed -i -re "s#-([LI]).*/Build/Install(.*)#-\1$out\2#g" Install/lib/pkgconfig/*.pc
    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      fixRunPath $f
    done
 
    cp -r Install/* $out
  '';

  dontStrip = true;

  buildInputs = [ cmake jsoncpp argtable curl libmicrohttpd doxygen catch ];

  meta = with stdenv.lib; {
    description = "C++ framework for json-rpc (json remote procedure call)";
    homepage = https://github.com/cinemast/libjson-rpc-cpp;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
