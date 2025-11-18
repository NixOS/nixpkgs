{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds-xbom-lib";
  version = "6.0.0b5";
  pyproject = true;

  # pypi because library is embedded into another project's repo
  src = fetchPypi {
    inherit version;
    pname = "ds_xbom_lib";
    hash = "sha256-IAqKqwetoQu1Fwb2tr4UjA3WztIIq5so/WE++Ov0VTw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "xbom_lib" ];

  # no tests
  doCheck = false;

  meta = {
    description = "xBOM library for owasp depscan";
    homepage = "https://pypi.org/project/ds-xbom-lib/";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.ngi ];
    license = with lib.licenses; [ mit ];
  };
}
