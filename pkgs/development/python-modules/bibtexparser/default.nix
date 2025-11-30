{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-9m+7RbeJMJssviyIezPrSLMMGcQTHYaOFQwLhnu04Es=";
  };

  propagatedBuildInputs = [ pyparsing ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bibtexparser" ];

  meta = with lib; {
    description = "Bibtex parser for Python";
    homepage = "https://github.com/sciunto-org/python-bibtexparser";
    license = with licenses; [
      lgpl3Only # or
      bsd3
    ];
  };
}
