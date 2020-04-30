{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkgconfig
, boost17x
, openssl
, zlib
, libsodium
, olm
, spdlog
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "mtxclient";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "v${version}";
    sha256 = "0vf5xmn6yfi5lvskfgrdmnalvclzrapcrml92bj9qaa8vq8mfsf2";
  };

  cmakeFlags = [
    # Network requiring tests can't be disabled individually:
    # https://github.com/Nheko-Reborn/mtxclient/issues/22
    "-DBUILD_LIB_TESTS=OFF"
    "-DBUILD_LIB_EXAMPLES=OFF"
    "-Dnlohmann_json_DIR=${nlohmann_json}/lib/cmake/nlohmann_json"
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  buildInputs = [
    spdlog
    boost17x
    openssl
    zlib
    libsodium
    olm
  ];

  meta = with stdenv.lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = "https://github.com/Nheko-Reborn/mtxclient";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;

    # As of 2019-06-30, all of the dependencies are available on macOS but the
    # package itself does not build.
    broken = stdenv.isDarwin;
  };
}
