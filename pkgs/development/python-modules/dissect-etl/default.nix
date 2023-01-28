{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-etl";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.etl";
    rev = version;
    hash = "sha256-s3Ls8tuqp/COBF+WV9RRyfo7FAqPcXmBZ08gHZMPzOU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.etl"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Event Trace Log (ETL) files";
    homepage = "https://github.com/fox-it/dissect.etl";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
