{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "1.0.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "v${version}";
    sha256 = "15vzk4p6bq8q5s2kmh31q7b9nngybbpn5jrkw029xrhh4alj9083";
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
