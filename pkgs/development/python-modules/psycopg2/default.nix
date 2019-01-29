{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.7.6.1";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "27959abe64ca1fc6d8cd11a71a1f421d8287831a3262bd4cacd43bbf43cc3c82";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  propagatedBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
