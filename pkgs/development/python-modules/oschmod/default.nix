{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oschmod";
  version = "0.3.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vsmSFvMWFe5lOypch8rPtOS2GEwOn3HaGGMA2srpdPM=";
  };
  build-system = [ setuptools ];

  meta = {
    description = "Change file permissions on Windows, macOS, and Linux";
    homepage = "https://github.com/yakdriver/oschmod";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gordon-bp ];
  };
}
