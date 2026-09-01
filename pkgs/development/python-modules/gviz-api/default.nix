{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "gviz_api";
  version = "1.10.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-hGaS3YzHMiT8MbGOQVib2TThzAUJDGV2r0tLJsLnG5A=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  meta = {
    description = "Python API for Google Visualization";
    homepage = "https://developers.google.com/chart/interactive/docs/dev/gviz_api_lib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
