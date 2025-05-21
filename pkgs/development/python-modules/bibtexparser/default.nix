{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pylatexenc,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "2.0.0b8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-531Mh/5DUYayXm1H0v4dPX0P9mRcqcQcU/A+f4wwqxg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pylatexenc ];

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
