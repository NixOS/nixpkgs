{ stdenv, grpc, curl, cmake, pkgconfig, fetchFromGitHub, doxygen, protobuf, crc32c, c-ares, nlohmann_json, fetchurl }:
let
  googleapis_rev = "a8ee1416f4c588f2ab92da72e7c1f588c784d3e6";
  googleapis = fetchurl {
    name = "${googleapis_rev}.tar.gz";
    url = "https://github.com/googleapis/googleapis/archive/${googleapis_rev}.tar.gz";
    sha256 = "1kxi27r034p7jfldhvgpbn6rqqqddycnja47m6jyjxj4rcmrp2kb";
  };
in stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    rev = "v${version}";
    sha256 = "1w942gzyv01ym1cv2a417x92zxra9s2v3xz5crcv84j919f616f8";
  };

  buildInputs = [ curl grpc protobuf nlohmann_json crc32c c-ares c-ares.cmake-config ];
  nativeBuildInputs = [ cmake pkgconfig doxygen ];

  outputs = [ "out" "dev" ];

  postPatch = ''
    NLOHMANN_SHA256=$(sha256sum ${nlohmann_json}/include/nlohmann/json.hpp | cut -f1 -d' ')
    sed -e 's,https://github.com/nlohmann/json/releases/download/.*,file://${nlohmann_json}/include/nlohmann/json.hpp"),' \
        -e "s,JSON_SHA256 .*,JSON_SHA256 ''${NLOHMANN_SHA256}," \
        -i cmake/DownloadNlohmannJson.cmake

    sed -e 's,https://github.com/googleapis/googleapis/archive/${googleapis_rev}.tar.gz,file://${googleapis},' \
        -i cmake/external/googleapis.cmake

    # Fixup the library path. It would build a path like /build/external//nix/store/…-foo/lib/foo.so for each library instead of /build/external/lib64/foo.so
    sed -e 's,''${CMAKE_INSTALL_LIBDIR},lib64,g' \
        -e 's,;lib64,lib,g' \
        -i cmake/ExternalProjectHelper.cmake
  '';

  preFixup = ''
    mv --no-clobber $out/lib64/cmake/* $out/lib/cmake
    mv --no-clobber $out/lib64/pkgconfig/* $out/lib/pkgconfig
    rmdir $out/lib64/cmake $out/lib64/pkgconfig
    find $out/lib64

    for file in $out/lib/pkgconfig/*; do
      sed -e 's,\''${prefix}//,/,g' -i $file
    done
  '';

  cmakeFlags = [
    "-DGOOGLE_CLOUD_CPP_BIGTABLE_ENABLE_INSTALL=no"
    "-DGOOGLE_CLOUD_CPP_DEPENDENCY_PROVIDER=package"
    "-DGOOGLE_CLOUD_CPP_GOOGLEAPIS_PROVIDER=external"
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DGOOGLE_CLOUD_CPP_INSTALL_RPATH=$(out)/lib"
  ];

  meta = with stdenv.lib; {
    license = with licenses; [ asl20 ];
    homepage = https://github.com/googleapis/google-cloud-cpp;
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    maintainers = with maintainers; [ andir ];
  };
}
