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
  version = "4.10.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wjrSPFIdgYlVpBUaZ9gVgDGdS/VI09SfQiOuBB/5iJE=";
  };

  propagatedBuildInputs = [
    html5lib
    lxml
    soupsieve
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bs4" ];

  meta = with lib; {
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
