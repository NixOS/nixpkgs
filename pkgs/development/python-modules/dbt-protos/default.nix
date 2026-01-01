{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "dbt-protos";
<<<<<<< HEAD
  version = "1.0.413";
=======
  version = "1.0.380";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "proto-python-public";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-WY8q06FyZliwdbIcLZPzpEpdxG6AeK+6EQU4bm8e4EE=";
=======
    hash = "sha256-gXaIIcxIKnUe4Pz5CidfWtM3iofUizJ+lXWNcTzL2pY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
