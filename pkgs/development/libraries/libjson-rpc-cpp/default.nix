{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, argtable
, catch2
, curl
, doxygen
, hiredis
, jsoncpp
, libmicrohttpd
}:

stdenv.mkDerivation rec {
  pname = "libjson-rpc-cpp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cinemast";
    repo = "libjson-rpc-cpp";
    sha256 = "sha256-EAakiqlfMprwLjloDekOssaB/EnAmn5njcwHGZtYs9w=";
    rev = "v${version}";
  };

  env.NIX_CFLAGS_COMPILE = "-I${catch2}/include/catch2";

  patches = [
    (fetchpatch {
      name = "int-to-MHD_Result.patch";
      url = "https://patch-diff.githubusercontent.com/raw/cinemast/libjson-rpc-cpp/pull/299.patch";
      sha256 = "sha256-hiey6etzbOxhMElTMX7offKbey7c2OO/UWeN03k0AaM=";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake doxygen ];
  buildInputs = [
    argtable
    catch2
    curl
    hiredis
    jsoncpp
    libmicrohttpd
  ];

  postPatch = ''
    for f in cmake/FindArgtable.cmake \
             src/stubgenerator/stubgenerator.cpp \
             src/stubgenerator/stubgeneratorfactory.cpp
    do
      sed -i -re 's/argtable2/argtable3/g' $f
    done

    sed -i -re 's#MATCHES "jsoncpp"#MATCHES ".*/jsoncpp/json$"#g' cmake/FindJsoncpp.cmake
  '';

  preConfigure = ''
    mkdir -p Build/Install
    pushd Build
  '';

  # this hack is needed because the cmake scripts
  # require write permission to absolute paths
  configurePhase = ''
    runHook preConfigure
    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install \
             -DCMAKE_BUILD_TYPE=Release
    runHook postConfigure
  '';

  preInstall = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      q="$p:${lib.makeLibraryPath [ jsoncpp argtable libmicrohttpd curl ]}:$out/lib"
      patchelf --set-rpath $q $1
    }

    mkdir -p $out
  '';

  postInstall = ''
    sed -i -re "s#-([LI]).*/Build/Install(.*)#-\1$out\2#g" Install/lib64/pkgconfig/*.pc
    for f in Install/lib64/*.so* $(find Install/bin -executable -type f); do
      fixRunPath $f
    done
    cp -r Install/* $out
  '';

  installPhase = ''
    runHook preInstall
    make install
    runHook postInstall
  '';

  meta = with lib; {
    description = "C++ framework for json-rpc (json remote procedure call)";
    mainProgram = "jsonrpcstub";
    homepage = "https://github.com/cinemast/libjson-rpc-cpp";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
