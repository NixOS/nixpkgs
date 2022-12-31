{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, traitlets
, pytestCheckHook
}:

let
  pname = "comm";
  version = "0.1.2";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "comm";
    rev = "refs/tags/${version}";
    hash = "sha256-Ve6tCvu89P5wUOj+vlzXItRR5RjJNKxItKnWP2fVk9U=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    traitlets
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Jupyter Python Comm implementation, for usage in ipykernel, xeus-python etc";
    homepage = "https://github.com/ipython/comm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

