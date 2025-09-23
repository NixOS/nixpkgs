{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "dbt-protos";
  version = "1.0.376";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "proto-python-public";
    tag = "v${version}";
    hash = "sha256-sBrpD2U220fBJzMBfqrXjWjtZ9qNS80gg8Lj4ngYHZE=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
