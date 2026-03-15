{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage rec {
  pname = "chardet";
  version = "7.4.1";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zaQRMqRd+/aYTa3h9TGkCYyBPK8mbGbMRG2Qu5Npyr0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = {
    description = "Universal character encoding detector";
    homepage = "https://github.com/chardet/chardet";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
