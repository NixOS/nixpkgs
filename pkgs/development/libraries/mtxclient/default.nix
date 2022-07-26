{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, openssl
, olm
, spdlog
, nlohmann_json
, coeurl
, libevent
, curl
}:

stdenv.mkDerivation rec {
  pname = "mtxclient";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "v${version}";
    sha256 = "sha256-SQoPeUdDNQU4qYDd8udQnIJ6PrZFtEOmf9uqnw1+fz4=";
  };

  postPatch = ''
    # See https://github.com/gabime/spdlog/issues/1897
    sed -i '1a add_compile_definitions(SPDLOG_FMT_EXTERNAL)' CMakeLists.txt
  '';

  cmakeFlags = [
    # Network requiring tests can't be disabled individually:
    # https://github.com/Nheko-Reborn/mtxclient/issues/22
    "-DBUILD_LIB_TESTS=OFF"
    "-DBUILD_LIB_EXAMPLES=OFF"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    spdlog
    nlohmann_json
    openssl
    olm
    coeurl
    libevent
    curl
  ];

  meta = with lib; {
    description = "Client API library for the Matrix protocol.";
    homepage = "https://github.com/Nheko-Reborn/mtxclient";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz pstn ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.targetPlatform.isDarwin;
  };
}
