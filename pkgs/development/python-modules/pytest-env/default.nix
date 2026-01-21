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
  version = "1.1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
    hash = "sha256-kSCYQKoOQzhQc6xGSlVK0pR8wv1mOp3r+I0DsB4Mwc8=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
}
