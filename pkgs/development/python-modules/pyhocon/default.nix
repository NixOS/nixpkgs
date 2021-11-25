{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pyparsing
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  pname = "pyhocon";
  version = "0.3.58";

  src = fetchFromGitHub {
    owner = "chimpler";
    repo = "pyhocon";
    rev = version;
    sha256 = "sha256-ddspVDKy9++cISWH6R95r+gJrzNGqMTybI04OgVtIUU=";
  };

  propagatedBuildInputs = [
    pyparsing
    python-dateutil
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhocon" ];

  meta = with lib; {
    homepage = "https://github.com/chimpler/pyhocon/";
    description = "HOCON parser for Python";
    # taken from https://pypi.org/project/pyhocon/
    longDescription = ''
      A HOCON parser for Python. It additionally provides a tool
      (pyhocon) to convert any HOCON content into json, yaml and properties
      format
    '';
    license = licenses.asl20;
    maintainers = [ maintainers.chreekat ];
  };
}
