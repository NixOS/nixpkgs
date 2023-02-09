{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, coeurl
, curl
, libevent
, nlohmann_json
, olm
, openssl
, re2
, spdlog
}:

stdenv.mkDerivation rec {
  pname = "mtxclient";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "v${version}";
    hash = "sha256-34iwYn9EOAl2c9UWERyzgwlZ+539jW9FygNYwgZ7ClU=";
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
    coeurl
    curl
    libevent
    nlohmann_json
    olm
    openssl
    re2
    spdlog
  ];

  # https://github.com/NixOS/nixpkgs/issues/201254
  NIX_LDFLAGS = lib.optionalString (stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU) "-lgcc";

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
