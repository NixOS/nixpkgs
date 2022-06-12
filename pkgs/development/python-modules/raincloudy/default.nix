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
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vanstinator";
    repo = pname;
    rev = version;
    hash = "sha256-c6tux0DZY56a4BpuiMXtaqm8+JKNDiyMxrFUju3cp2Y=";
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
