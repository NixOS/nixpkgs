{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, boost, openssl, zlib, libsodium, olm, nlohmann_json }:

stdenv.mkDerivation rec {
  pname = "mtxclient";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "v${version}";
    sha256 = "0pycznrvj57ff6gbwfn1xj943d2dr4vadl79hii1z16gn0nzxpmj";
  };

  cmakeFlags = [
    "-DBUILD_LIB_TESTS=OFF"
    "-DBUILD_LIB_EXAMPLES=OFF"
    "-Dnlohmann_json_DIR=${nlohmann_json}/lib/cmake/nlohmann_json"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost openssl zlib libsodium olm ];

  meta = with stdenv.lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = https://github.com/Nheko-Reborn/mtxclient;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;

    # As of 2019-06-30, all of the dependencies are available on macOS but the
    # package itself does not build.
    broken = stdenv.isDarwin;
  };
}
