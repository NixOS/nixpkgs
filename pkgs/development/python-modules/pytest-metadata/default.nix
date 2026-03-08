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
  pname = "pytest-metadata";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_metadata";
    inherit version;
    hash = "sha256-0qKbA1X7wD8WiqltQf+IsaO0SjsCrL5JGAHJigSAF8g=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mpoquet ];
  };
}
