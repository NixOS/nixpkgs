{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core_3,
}:

buildPythonPackage (finalAttrs: {
  pname = "py3dns";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-mGUugOzsFDxg948OazQWMcqadWDt2N3fyGTAKQJhijk=";
  };

  build-system = [ flit-core_3 ];

  doCheck = false;

  meta = {
    description = "Python 3 DNS library";
    homepage = "https://launchpad.net/py3dns";
    license = lib.licenses.psfl;
  };
})
