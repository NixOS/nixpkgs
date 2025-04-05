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
  version = "2.7.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fP+qFbMQGB9E8nocoNkXgru4mjONSNw2zeBa4CpDbGw=";
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
