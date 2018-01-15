{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff6d2e2962d834acb125cc4dcc80c54a8c17c253f4cc9d9c43b5102a560bb75d";
  };

  meta = with stdenv.lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = https://github.com/berkerpeksag/astor;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
