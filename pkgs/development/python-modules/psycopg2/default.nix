{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.7.7";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4526d078aedd5187d0508aa5f9a01eae6a48a470ed678406da94b4cd6524b7e";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
