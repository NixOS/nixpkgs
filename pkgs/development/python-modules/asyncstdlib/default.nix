{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.10.3";
  disabled = pythonOlder "3.7";
  format = "flit";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q547XKsn4/U7XbDhZADF4qPpFxAGPmv9bAXSQZnNUIo=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asyncstdlib" ];

  meta = with lib; {
    description = "Python library that extends the Python asyncio standard library";
    homepage = "https://asyncstdlib.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
