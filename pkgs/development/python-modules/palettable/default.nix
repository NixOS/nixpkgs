{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "palettable";
  version = "3.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CU3X2aX8HMpIVHc+XB/GoxWzO9WzqPRwZJKPrK8EkKg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "palettable"
    "palettable.matplotlib"
    "palettable.tableau"
  ];

  meta = {
    description = "Library of color palettes";
    homepage = "https://jiffyclub.github.io/palettable/";
    changelog = "https://github.com/jiffyclub/palettable/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
