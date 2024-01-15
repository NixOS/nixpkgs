{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, pillow
, poetry-core
, requests
, rich
}:

buildPythonPackage rec {
  pname = "getjump";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rNMhyUqrliKf6CPhZfyUwN00D4TgOWjPCoqihOB0PDE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    pillow
    requests
    rich
  ];

  pythonImportsCheck = [
    "getjump"
  ];

  # all the tests talk to the internet
  doCheck = false;

  meta = with lib; {
    description = "Get and save images from jump web viewer";
    homepage = "https://github.com/eggplants/getjump";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "jget";
  };
}
