{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "amberelectric";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gxpFKIrGHpwjPdF0nnyruwCYf3bhrubdtXNx2+wEiZU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    urllib3
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "amberelectric" ];

  meta = with lib; {
    description = "Python Amber Electric API interface";
    homepage = "https://github.com/madpilot/amberelectric.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
