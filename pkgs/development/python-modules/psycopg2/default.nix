{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.7.5";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17klx964gw8z0znl0raz3by8vdc7cq5gxj4pdcrfcina84nrdkzc";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  propagatedBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
