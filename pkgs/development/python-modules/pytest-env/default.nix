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
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
    hash = "sha256-R14uvoYmzuAfSR8wSnSxITd0I5fWx4TqS8JY8GkjK4A=";
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
