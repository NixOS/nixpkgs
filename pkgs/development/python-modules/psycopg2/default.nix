{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi, postgresql, openssl }:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.8.5";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7d46240f7a1ae1dd95aab38bd74f7428d46531f69219954266d669da60c0818";
  };

  buildInputs = lib.optional stdenv.isDarwin openssl;
  nativeBuildInputs = [ postgresql ];

  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    license = with licenses; [ gpl2 zpl20 ];
  };
}
