{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-motionmount";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vogelsproducts";
    repo = "python-MotionMount";
    rev = "refs/tags/${version}";
    hash = "sha256-07wTlyfUSt44dBwOXjkXADA+HDy8531KYxJAKqBWKeQ=";
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
