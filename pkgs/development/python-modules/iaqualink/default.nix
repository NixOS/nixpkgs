{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-runner
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "iaqualink";
  version = "0.4.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    rev = "v${version}";
    sha256 = "13iwngjjqzr1pkmskbc2wakccvcjkf4bk65f4jp4ywpciilr4zjw";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iaqualink" ];

  meta = with lib; {
    description = "Python library for Jandy iAqualink";
    homepage = "https://github.com/flz/iaqualink-py";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
