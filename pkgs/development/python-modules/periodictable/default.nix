{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "periodictable";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-periodictable";
    repo = "periodictable";
    tag = "v${version}";
    hash = "sha256-nI6hiLnqmVXT06pPkHCBEMTxZhfnZJqSImW3V9mJ4+8=";
  };

  propagatedBuildInputs = [
    numpy
    pyparsing
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "periodictable" ];

  meta = with lib; {
    description = "Extensible periodic table of the elements";
    homepage = "https://github.com/pkienzle/periodictable";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rprospero ];
  };
}
