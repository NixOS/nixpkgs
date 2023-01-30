{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-ole";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ole";
    rev = version;
    hash = "sha256-0bIlnRFKBvSXnBIU4+1V7WzyXCvulUpNSXG1Rj2k4jY=";
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

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dissect.ole"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Object Linking & Embedding (OLE) format";
    homepage = "https://github.com/fox-it/dissect.ole";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
