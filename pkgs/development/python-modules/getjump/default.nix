{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pillow,
  poetry-core,
  pythonOlder,
  requests,
  rich,
}:

buildPythonPackage rec {
  pname = "getjump";
  version = "2.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tIM7gsgh8DDPphGsrGeV6Y3RmAjdxw9MgxDIt+EQwF0=";
  };

  pythonRelaxDeps = [ "pillow" ];

  build-system = [ poetry-core ];

  dependencies = [
    beautifulsoup4
    pillow
    requests
    rich
  ];

  pythonImportsCheck = [ "getjump" ];

  # all the tests talk to the internet
  doCheck = false;

  meta = with lib; {
    description = "Get and save images from jump web viewer";
    homepage = "https://github.com/eggplants/getjump";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "jget";
  };
}
