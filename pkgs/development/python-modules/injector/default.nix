<<<<<<< HEAD
{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, typing-extensions
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "injector";
  version = "0.21.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-injector";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5O4vJSXfYNTrUzmv5XuT9pSUndNSvTZTxfVwiAd+0ck=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

=======
{ lib, buildPythonPackage, fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hmG0mi+DCc5h46aoK3rLXiJcS96OF9FhDIk6Zw3/Ijo=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  doCheck = false; # No tests are available
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "injector" ];

  meta = with lib; {
    description = "Python dependency injection framework, inspired by Guice";
    homepage = "https://github.com/alecthomas/injector";
    maintainers = [ maintainers.ivar ];
    license = licenses.bsd3;
  };
}
