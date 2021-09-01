{ lib, buildPythonPackage, fetchFromSourcehut, sqlparse, wrapt, pytestCheckHook }:

buildPythonPackage rec {
  pname = "embrace";
  version = "4.0.0";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~olly";
    repo = "embrace-sql";
    rev = "v${version}-release";
    sha256 = "sha256-G/7FeKlMbOWobQOpD7/0JiTFpf8oWZ1TxPpDS9wrKMo=";
  };

  propagatedBuildInputs = [ sqlparse wrapt ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "embrace" ];

  meta = with lib; {
    description = "Embrace SQL keeps your SQL queries in SQL files";
    homepage = "https://pypi.org/project/embrace/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
  };
}
