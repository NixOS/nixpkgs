{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  boto3,
  moto,
}:

buildPythonPackage rec {
  pname = "bucketstore";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "bucketstore";
    rev = "refs/tags/${version}";
    hash = "sha256-BtoyGqFbeBhGQeXnmeSfiuJLZtXFrK26WO0SDlAtKG4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=__version__," 'version="${version}",'
  '';

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
