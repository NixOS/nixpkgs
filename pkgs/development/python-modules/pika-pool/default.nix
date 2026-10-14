{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pika,
}:

buildPythonPackage rec {
  pname = "pika-pool";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-85hYiMwniM29KTpoqLVwKpyVXbb3uLVRrqyR5/Mto5c=";
  };

  pythonRelaxDeps = [ "pika" ];

  build-system = [ setuptools ];

  # Tests require database connections
  doCheck = false;

  dependencies = [ pika ];
  meta = {
    homepage = "https://github.com/bninja/pika-pool";
    license = lib.licenses.bsdOriginal;
    description = "Pools for pikas";
  };
}
