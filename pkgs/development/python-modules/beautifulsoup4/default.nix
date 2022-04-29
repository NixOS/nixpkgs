{ lib
, buildPythonPackage
, fetchPypi
, html5lib
, lxml
, pytestCheckHook
, pythonOlder
, soupsieve
}:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rZqlW2XvKAjrQF9Gz3Tff8twRNXLwmSH+W6y7y5DZpM=";
  };

  propagatedBuildInputs = [
    html5lib
    lxml
    soupsieve
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bs4"
  ];

  meta = with lib; {
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
