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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CU3X2aX8HMpIVHc+XB/GoxWzO9WzqPRwZJKPrK8EkKg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "palettable"
    "palettable.matplotlib"
    "palettable.tableau"
  ];

  meta = with lib; {
    description = "A library of color palettes";
    homepage = "https://jiffyclub.github.io/palettable/";
    changelog = "https://github.com/jiffyclub/palettable/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
