{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.8.4";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f898e5cc0a662a9e12bde6f931263a1bbd350cfb18e1d5336a12927851825bb6";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
