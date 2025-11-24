{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oschmod";
  version = "0.3.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vsmSFvMWFe5lOypch8rPtOS2GEwOn3HaGGMA2srpdPM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oschmod" ];

  meta = {
    description = "Change file permissions on Windows, macOS, and Linux";
    homepage = "https://github.com/yakdriver/oschmod";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gordon-bp ];
  };
}
