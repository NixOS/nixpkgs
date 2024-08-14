{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KBD9sRqtQT02RfyXurUiGy28bucB7l/irF/fPmVeGwc=";
  };

  build-system = [ hatchling ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [ "pex" ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    changelog = "https://github.com/pantsbuild/pex/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      copumpkin
      phaer
    ];
  };
}
