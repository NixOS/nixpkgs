{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z+opmknmgyFwvKJyvrv3MMpo23etZCn4bxGTpG5d/dY=";
  };

  propagatedBuildInputs = [
    future
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/sciunto-org/python-bibtexparser/pull/259
    substituteInPlace bibtexparser/tests/test_crossref_resolving.py \
      --replace "import unittest2 as unittest" "import unittest"
  '';

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
