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
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gu6h9Yb0xdfvdmoeZGQPFCJhBJxuQ4iWlQquig1ljnY=";
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

  meta = with lib; {
    description = "Get and save images from jump web viewer";
    homepage = "https://github.com/eggplants/getjump";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    mainProgram = "jget";
  };
}
