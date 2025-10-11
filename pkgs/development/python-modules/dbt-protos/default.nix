{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "dbt-protos";
  version = "1.0.382";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "proto-python-public";
    tag = "v${version}";
    hash = "sha256-uuhfN3w1Kv5otQIc+5xjbQKn/WIwdgua4crTfMroc10=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    protobuf
  ];

  pythonImportsCheck = [
    "dbtlabs.proto.public.v1"
  ];

  meta = {
    description = "dbt public protos";
    homepage = "https://github.com/dbt-labs/proto-python-public";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
