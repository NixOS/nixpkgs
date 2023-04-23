{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, traitlets
, pytestCheckHook
}:

let
  pname = "comm";
  version = "0.1.3";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "comm";
    rev = "refs/tags/v${version}";
    hash = "sha256-5IUE2g00GT231hjuM7mLPst0QTk2Y+Re302FRDq65C8=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    traitlets
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Jupyter Python Comm implementation, for usage in ipykernel, xeus-python etc";
    homepage = "https://github.com/ipython/comm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

