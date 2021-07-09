{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, libevent
, pkg-config
, boost17x
, openssl
, olm
, spdlog
, nlohmann_json
, curl
, coeurl
}:

stdenv.mkDerivation rec {
  pname = "mtxclient";
  version = "0.5.1-git";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "0411d176f0d81f8f3eced2fa94e72b4585203a40";
    sha256 = "154p03k0y4q08ydpqkqs8sxjwk16r2xz9rar84s1y3d6hj497i4z";
  };

  # CXX_FLAGS = "-DSPDLOG_FMT_EXTERNAL";

  cmakeFlags = [
    # Network requiring tests can't be disabled individually:
    # https://github.com/Nheko-Reborn/mtxclient/issues/22
    "-DBUILD_LIB_TESTS=OFF"
    "-DBUILD_LIB_EXAMPLES=OFF"
    "-Dnlohmann_json_DIR=${nlohmann_json}/lib/cmake/nlohmann_json"
    # Can be removed once either https://github.com/NixOS/nixpkgs/pull/85254 or
    # https://github.com/NixOS/nixpkgs/pull/73940 are merged
    "-DBoost_NO_BOOST_CMAKE=TRUE"
    "-DCMAKE_CXX_FLAGS=-DSPDLOG_FMT_EXTERNAL" # HACK: Overwrites all other CXX_FLAGS!
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    coeurl
    libevent
    spdlog
    boost17x
    openssl
    olm
  ];

  meta = with lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = "https://github.com/Nheko-Reborn/mtxclient";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz pstn ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.targetPlatform.isDarwin;
  };
}
