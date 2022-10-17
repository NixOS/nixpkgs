{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "life360";
  version = "5.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Fsv0lK0C9suVqgeaxKVuyAacHzHJJ1FHXzzy95RnhWw=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "life360"
  ];

  meta = with lib; {
    description = "Python module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
