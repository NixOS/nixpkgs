{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,

  matplotlib,
  numpy,

  setuptools,
}:

buildPythonPackage rec {
  pname = "july";
  version = "0.1.3";
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0xXCSSEKf2COJ9IHfuy+vpC/Zieg+q6TTabEFmUspCM=";
  };

  patches = [
    # Fixes compatibility with current matplotlib versions
    (fetchpatch {
      url = "https://github.com/e-hulten/july/pull/44/commits/e5ff842bc98d3963c788737fff1b9086569b7d0a.patch";
      hash = "sha256-zgeUkDWCfAebt1rgDZgMUVgQF81NWGrG2tmSj4/ncYA=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    numpy
  ];

  pythonImportsCheck = [ "july" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Small library for creating pretty heatmaps of daily data";
    homepage = "https://github.com/e-hulten/july";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
