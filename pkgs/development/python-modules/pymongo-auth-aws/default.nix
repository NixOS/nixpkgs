{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  hatchling,
  hatch-requirements-txt,

  # dependencies
  boto3,
  botocore,

  # test dependencies
  pymongo,
  pytestCheckHook,
}:

let
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "pymongo-auth-aws";
    tag = version;
    hash = "sha256-532Srsaa1wlFoK4BHiTTl8CtdJ3MBnEm7Apqg05vv0w=";
  };
in
buildPythonPackage {
  pname = "pymongo-auth-aws";
  inherit version src;
  pyproject = true;

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    boto3
    botocore
  ];

  nativeCheckInputs = [
    pymongo
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mongodb/pymongo-auth-aws/blob/${src.tag}/CHANGELOG.rst";
    description = "MONGODB-AWS authentication mechanism for PyMongo";
    homepage = "https://github.com/mongodb/pymongo-auth-aws";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ deshaw ];
  };
}
