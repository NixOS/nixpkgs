{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "1.0.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    sha256 = "00kq3dsjcfhjzn585phb3g168dbg53wrqq7g8a4gljs49c2mf5qx";
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
