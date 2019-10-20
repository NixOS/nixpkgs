{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.8.3";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ms4kx0p5n281l89awccix4d05ybmdngnjjpi9jbzd0rhf1nwyl9";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
