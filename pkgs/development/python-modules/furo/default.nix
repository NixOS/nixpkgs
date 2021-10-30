{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2021.10.9";
  format = "flit";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K6pCoi7ePm6Vxhgqs2S6wuwVt5vH+cp/sJ/ZrsSzVAw=";
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
