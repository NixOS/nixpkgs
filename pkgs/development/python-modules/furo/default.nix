{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2021.9.22";
  format = "flit";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-749l6cXyGbIarXXJmiCU0DsWQwrvH1dobOGePyT5VK8=";
  };

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
  ];

  pythonImportsCheck = [ "furo" ];

  meta = with lib; {
    description = "A clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
