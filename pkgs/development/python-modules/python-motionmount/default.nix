{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-motionmount";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vogelsproducts";
    repo = "python-MotionMount";
    tag = version;
    hash = "sha256-cXh+7DNbwYoKp76XmzPno6dcfujZT/QUO3Ns72M4gV0=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "motionmount" ];

  meta = with lib; {
    description = "Module to control the TVM7675 Pro (Signature) series of MotionMount";
    homepage = "https://github.com/vogelsproducts/python-MotionMount";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
