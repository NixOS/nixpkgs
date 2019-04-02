{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, boost, openssl, zlib, libsodium, olm, gtest, spdlog, nlohmann_json }:

stdenv.mkDerivation rec {
  name = "mtxclient-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mujx";
    repo = "mtxclient";
    rev = "v${version}";
    sha256 = "19v1qa6mzvc65m7wy7x0g4i24bcg9xk31y1grwvd3zr0l4v6xcgs";
  };

  patches = [
    # remove on the next mtxclient update
    (fetchpatch {
      url = "https://github.com/Nheko-Reborn/mtxclient/commit/41314809da7eb17ec00cff1795af6a528c5e904a.diff";
      sha256 = "17pzrkdhd4jr8xwd7hhyzak880k8yb9nkg3vcbyjfp5si89dha5j";
    })
  ];

  postPatch = ''
    ln -s ${nlohmann_json}/include/nlohmann/json.hpp include/json.hpp
  '';

  cmakeFlags = [ "-DBUILD_LIB_TESTS=OFF" "-DBUILD_LIB_EXAMPLES=OFF" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost openssl zlib libsodium olm ];

  meta = with stdenv.lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = https://github.com/mujx/mtxclient;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
