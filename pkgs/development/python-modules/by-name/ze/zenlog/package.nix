{
  buildPythonPackage,
  fetchPypi,
  lib,
  colorlog,
  setuptools,
}:
let
  pname = "zenlog";
  version = "1.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g0YKhfpySbgAfANoGmoLV1zm/gRDSTidPT1D9Y1Gh94=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorlog ];

  meta = {
    description = "Python script logging for the lazy";
    homepage = "https://github.com/ManufacturaInd/python-zenlog";
    changelog = "https://github.com/ManufacturaInd/python-zenlog/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
}
