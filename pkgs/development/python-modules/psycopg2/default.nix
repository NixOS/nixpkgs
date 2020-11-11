{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.8.6";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb23f6c71107c37fd667cb4ea363ddeb936b348bbd6449278eb92c189699f543";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
