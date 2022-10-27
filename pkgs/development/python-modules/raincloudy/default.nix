{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, html5lib
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, urllib3
}:

buildPythonPackage rec {
  pname = "raincloudy";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vanstinator";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qCkBVirM09iA1sXiOB9FJns8bHjQq7rRk8XbRWrtBDI=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
    urllib3
    html5lib
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    # https://github.com/vanstinator/raincloudy/pull/60
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4" \
      --replace "html5lib==1.0.1" "html5lib"
  '';

  pythonImportsCheck = [
    "raincloudy"
  ];

  disabledTests = [
    # Test requires network access
    "test_attributes"
  ];

  meta = with lib; {
    description = "Module to interact with Melnor RainCloud Smart Garden Watering Irrigation Timer";
    homepage = "https://github.com/vanstinator/raincloudy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
