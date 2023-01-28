{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "1.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yKeG0UCQ8haT1hvywoIwKQ519GK2wFg0wXaRTFeKYIk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError, https://github.com/timmo001/aiolyric/issues/5
    "test_location"
  ];

  pythonImportsCheck = [
    "aiolyric"
  ];

  meta = with lib; {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
