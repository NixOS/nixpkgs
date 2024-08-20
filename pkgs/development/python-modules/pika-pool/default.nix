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
    sha256 = "f3985888cc2788cdbd293a68a8b5702a9c955db6f7b8b551aeac91e7f32da397";
  };

  pythonRelaxDeps = [ "pika" ];

  build-system = [ setuptools ];

  # Tests require database connections
  doCheck = false;

  dependencies = [ pika ];
  meta = with lib; {
    homepage = "https://github.com/bninja/pika-pool";
    license = licenses.bsdOriginal;
    description = "Pools for pikas";
  };
}
