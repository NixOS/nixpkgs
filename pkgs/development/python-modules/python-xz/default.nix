{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "python-xz";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "python_xz";
    hash = "sha256-yNxRBweZ7p533dndIHoRzJFw6SmFQvgecYcHLg1UNHg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "xz" ];

  meta = {
    description = "Pure Python library for seeking within compressed xz files";
    homepage = "https://github.com/Rogdham/python-xz";
    changelog = "https://github.com/Rogdham/python-xz/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = lib.platforms.all;
  };
}
