{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, zlib, pcre2, expat, sqlite, openssl, unixODBC, libmysqlclient }:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "pocoproject";
    repo = "poco";
    sha256 = "sha256-GcwkGiui9j9RzMQyEEmqq8dxWzKpv5xWxJgvJpSMdbw=";
    rev = "poco-${version}-release";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ unixODBC libmysqlclient ];
  propagatedBuildInputs = [ zlib pcre2 expat sqlite openssl ];

  outputs = [ "out" "dev" ];

  MYSQL_DIR = libmysqlclient;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  configureFlags = [
    "--unbundled"
  ];

  postFixup = ''
    grep -rlF INTERFACE_INCLUDE_DIRECTORIES "$dev/lib/cmake/Poco" | while read -r f; do
      substituteInPlace "$f" \
        --replace "$"'{_IMPORT_PREFIX}/include' ""
    done
  '';

  meta = with lib; {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej tomodachi94 ];
    platforms = platforms.unix;
  };
}
