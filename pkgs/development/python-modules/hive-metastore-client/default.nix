{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  thrift,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hive-metastore-client";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quintoandar";
    repo = "hive-metastore-client";
    tag = version;
    hash = "sha256-IejsiC1eDNa6fjpQPhLNkMvZpyr9QsQdGBfhev1jEyg=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "thrift"
  ];
  dependencies = [
    thrift
  ];

  pythonImportsCheck = [ "hive_metastore_client" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Client for connecting and running DDLs on hive metastore";
    homepage = "https://github.com/quintoandar/hive-metastore-client";
    changelog = "https://github.com/quintoandar/hive-metastore-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
