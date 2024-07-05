{
  lib,
  buildPythonPackage,
  fetchPypi,
  py,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-random-order";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RHLX008fHF86NZxP/FwT7QZSMvMeyhnIhEwatAbnkIA=";
  };

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    py
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "random_order" ];

  meta = with lib; {
    homepage = "https://github.com/jbasko/pytest-random-order";
    description = "Randomise the order of tests with some control over the randomness";
    changelog = "https://github.com/jbasko/pytest-random-order/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
