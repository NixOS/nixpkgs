{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.7.6";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a658550b0bcb259e97f77f2dc93ed6b108fe2eda963a9e6fc8b48040d542ec2";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  propagatedBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
