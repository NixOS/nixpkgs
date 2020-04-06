{ stdenv, lib, buildPythonPackage, fetchPypi, cffi, postgresql, openssl, six }:

buildPythonPackage rec {
  pname = "psycopg2cffi";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yc0cxxkfr35kd959wsagxfhy6ikbix71rp9x0rmn858fxa4vapw";
  };

  buildInputs = [ six ] ++ lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ cffi postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ lgpl3 ];
    homepage = "http://github.com/chtd/psycopg2cffi/";
    maintainers = with maintainers; [ bqv ];
  };
}
