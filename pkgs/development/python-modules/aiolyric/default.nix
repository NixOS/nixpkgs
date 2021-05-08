{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "1.0.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lnzsdw6kvgk0762f3vyw4xfzn7qkvsff16q61gm0ryjqg9j8whx";
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
