{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  boto3,
  moto,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "bucketstore";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "bucketstore";
    tag = version;
    hash = "sha256-WjweYFnlDEoR+TYzNgjPMdCLdUUEbdPROubov6kancc=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [ boto3 ];

  nativeCheckInputs = [
    moto
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bucketstore" ];

  meta = {
    description = "Library for interacting with Amazon S3";
    homepage = "https://github.com/jpetrucciani/bucketstore";
    changelog = "https://github.com/jpetrucciani/bucketstore/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
