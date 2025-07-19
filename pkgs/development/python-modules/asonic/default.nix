{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asonic";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cw9Pk4DQBH48RA3d0C63k2V2hsiQqNx1bQI3r0nhki8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "asonic" ];

  meta = {
    description = "Async Python Client for the Sonic Search Engine";
    homepage = "https://github.com/moshe/asonic";
    changelog = "https://github.com/moshe/asonic/releases/tag/v${version}";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ PapayaJackal ];
  };
}
