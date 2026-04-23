{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "dash-core-components";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "dash_core_components";
    inherit (finalAttrs) version;
    hash = "sha256-xnM4dK+XXlUvlaE5ihbC7n3xTOQ/pguzcYo8bgtj/+4=";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Dash component starter pack";
    homepage = "https://dash.plot.ly/dash-core-components";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antoinerg ];
  };
})
