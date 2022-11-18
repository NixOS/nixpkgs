{ lib
, async_generator
, buildPythonPackage
, docutils
, fetchFromGitHub
, geographiclib
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "geopy";
  version = "2.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-bHfjUfuiEH3AxRDTLmbm67bKOw6fBuMQDUQA2NLg800=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "geographiclib<2,>=1.49" "geographiclib"
  '';

  propagatedBuildInputs = [
    geographiclib
  ];

  checkInputs = [
    async_generator
    docutils
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # ignore --skip-tests-requiring-internet flag
    "test_user_agent_default"
  ];

  pytestFlagsArray = [ "--skip-tests-requiring-internet" ];

  pythonImportsCheck = [ "geopy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://github.com/geopy/geopy";
    description = "Python Geocoding Toolbox";
    changelog = "https://github.com/geopy/geopy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
