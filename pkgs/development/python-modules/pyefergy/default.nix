{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, iso4217
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pyefergy";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = pname;
    rev = version;
    sha256 = "sha256-8xcKgsZ6buaQdrKD8Qn7jB5IlQ0NkR0nZGuFk+Dd8Q8=";
  };

  propagatedBuildInputs = [
    aiohttp
    iso4217
    pytz
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyefergy" ];

  meta = with lib; {
    description = "Python API library for Efergy energy meters";
    homepage = "https://github.com/tkdrob/pyefergy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
