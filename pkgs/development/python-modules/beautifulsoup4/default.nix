{ lib
, buildPythonPackage
, fetchPypi
, chardet
, html5lib
, lxml
, pytestCheckHook
, pythonOlder
, soupsieve
, sphinxHook
}:

buildPythonPackage rec {
  pname = "beautifulsoup4";
  version = "4.11.2";
  format = "setuptools";

  outputs = ["out" "doc"];

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vEvdpnF95aKYdDb7jXL0XckN2Fa9/VEqExTOkDSaAQY=";
  };

  nativeBuildInputs = [
    sphinxHook
  ];

  propagatedBuildInputs = [
    chardet
    html5lib
    lxml
    soupsieve
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bs4"
  ];

  meta = with lib; {
    changelog = "https://git.launchpad.net/beautifulsoup/tree/CHANGELOG?h=${version}";
    homepage = "http://crummy.com/software/BeautifulSoup/bs4/";
    description = "HTML and XML parser";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
