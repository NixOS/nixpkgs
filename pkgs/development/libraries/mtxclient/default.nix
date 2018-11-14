{ stdenv, fetchFromGitHub, cmake, pkgconfig
, boost, openssl, zlib, libsodium, olm, gtest, spdlog, nlohmann_json }:

stdenv.mkDerivation rec {
  name = "mtxclient-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mujx";
    repo = "mtxclient";
    rev = "v${version}";
    sha256 = "0i58y45diysayjzy5ick15356972z67dfxm0w41ay88nm42x1imp";
  };

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
