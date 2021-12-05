{ lib, aiohttp, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "1.0.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A4EkqSIQ5p4E4DPLYu9a/lmb1sFhwDqFLhjhZS6Zf5c=";
  };

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # AssertionError, https://github.com/timmo001/aiolyric/issues/5
    "test_location"
  ];
  pythonImportsCheck = [ "aiolyric" ];

  meta = with lib; {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
