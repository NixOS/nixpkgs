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
  version = "2.2.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-zFz0T/M/CABKkChuiKsFkWj2pphZuFeE5gz0HxZYaz8=";
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
