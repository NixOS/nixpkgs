{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, boto3
, moto
}:

buildPythonPackage rec {
  pname = "bucketstore";
  version = "0.2.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "bucketstore";
    rev = version;
    sha256 = "sha256-BtoyGqFbeBhGQeXnmeSfiuJLZtXFrK26WO0SDlAtKG4=";
  };

  propagatedBuildInputs = [ boto3 ];

  checkInputs = [
    pytestCheckHook
    moto
  ];

  pythonImportsCheck = [
    "bucketstore"
  ];

  meta = with lib; {
    description = "Library for interacting with Amazon S3";
    homepage = "https://github.com/jpetrucciani/bucketstore";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
