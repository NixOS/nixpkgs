{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  boto3,
  moto,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "bucketstore";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "bucketstore";
    rev = "refs/tags/${version}";
    hash = "sha256-WjweYFnlDEoR+TYzNgjPMdCLdUUEbdPROubov6kancc=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [ boto3 ];

  nativeCheckInputs = [
    moto
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bucketstore" ];

  meta = with lib; {
    description = "Library for interacting with Amazon S3";
    homepage = "https://github.com/jpetrucciani/bucketstore";
    changelog = "https://github.com/jpetrucciani/bucketstore/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
