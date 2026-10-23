{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytest,
  python-dotenv,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-env";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_env";
    inherit (finalAttrs) version;
    hash = "sha256-DB3BEB+406s2Eej41le6BsPAwWf8hckEV+WyfyUI9D4=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [ python-dotenv ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
})
