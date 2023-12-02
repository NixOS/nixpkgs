{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, traitlets
, pytestCheckHook
}:

let
  pname = "comm";
  version = "0.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "comm";
    rev = "refs/tags/v${version}";
    hash = "sha256-bErZNTm0spO0A/Lc8kq5u7sB0FMXm/WMWtFbCNGJVXE=";
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

