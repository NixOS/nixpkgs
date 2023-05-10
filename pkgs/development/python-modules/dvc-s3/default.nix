{ lib
, aiobotocore
, boto3
, buildPythonPackage
, fetchPypi
, flatten-dict
, pythonRelaxDepsHook
, s3fs
, setuptools-scm }:

buildPythonPackage rec {
  pname = "dvc-s3";
  version = "2.22.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-19j/JD8KZEQKaj55HYEucHwh/LUJ+88PPFEqAWov2Gg=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  # dvc-s3 uses boto3 directly, we add in propagatedBuildInputs
  postPatch = ''
    substituteInPlace setup.cfg --replace 'aiobotocore[boto3]' 'aiobotocore'
  '';

  nativeBuildInputs = [ setuptools-scm pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    aiobotocore boto3 flatten-dict s3fs
  ];

  # Network access is needed for tests
  doCheck = false;

  pythonCheckImports = [ "dvc_s3" ];

  meta = with lib; {
    description = "s3 plugin for dvc";
    homepage = "https://pypi.org/project/dvc-s3/${version}";
    changelog = "https://github.com/iterative/dvc-s3/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
