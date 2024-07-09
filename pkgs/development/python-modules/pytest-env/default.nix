{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-env";
  version = "1.1.3";
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
    hash = "sha256-/NfcI7tx79PTVjK94bvl7oyNxEidZhf7AQZ0iA2WIWs=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
