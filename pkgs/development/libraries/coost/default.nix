{ lib, stdenv, fetchFromGitHub, cmake, curl, openssl, gitUpdater
, withCurl ? true, withOpenSSL ? true }:

stdenv.mkDerivation rec {
  pname = "coost";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "idealvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qpJh1yl0lYYszNHGo5Jkbzal2hnVzg7UUxiyg/Grva8=";
  };

  postPatch = ''
    substituteInPlace cmake/coost.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional withCurl curl ++ lib.optional withOpenSSL openssl;

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ]
    ++ lib.optional withCurl "-DWITH_LIBCURL=ON"
    ++ lib.optional withOpenSSL "-DWITH_OPENSSL=ON";

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A tiny boost library in C++11";
    homepage = "https://github.com/idealvin/coost";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.unix;
  };
}
