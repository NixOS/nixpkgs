{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-dP3ETzgVPI4NsxFI6Hv+nUInrjF+I1FwdqmeAetzL38=";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bibtexparser"
  ];

  meta = with lib; {
    description = "Bibtex parser for Python";
    homepage = "https://github.com/sciunto-org/python-bibtexparser";
    license = with licenses; [ lgpl3Only /* or */ bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}
