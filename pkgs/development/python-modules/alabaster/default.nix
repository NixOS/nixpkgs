{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  flit-core,
  pygments,
}:

buildPythonPackage rec {
  pname = "alabaster";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wA3KV7yib6YqbX0Kn8zmXz4Cbpv+M+nFOP0/uyFE/Z4=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitprophet/alabaster";
    description = "Sphinx theme";
    license = licenses.bsd3;
  };
}
