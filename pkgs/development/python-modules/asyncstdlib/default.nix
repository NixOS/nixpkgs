{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncstdlib";
  version = "3.10.4";
  disabled = pythonOlder "3.7";
  format = "flit";

  src = fetchFromGitHub {
    owner = "maxfischer2781";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zPWXI5iHMCkSVjyNRcXplTadobYCeMv3Unjt+QVF8D8=";
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
