{ buildPythonPackage, fetchPypi, pytestCheckHook
, atpublic, psutil, pytestcov, sybil
}:

buildPythonPackage rec {
  pname = "flufl.lock";
  version = "5.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bnapkg99r6mixn3kh314bqcfk8q54y0cvhjpj87j7dhjpsakfpz";
  };

  propagatedBuildInputs = [ atpublic psutil ];
  checkInputs = [ pytestCheckHook pytestcov sybil ];
}
