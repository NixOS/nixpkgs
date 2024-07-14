{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "future-typing";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "future_typing";
    inherit version;
    hash = "sha256-Zf3FA0qV2yEnkP7l6Xf7Ci343rYNzPO6wX1tKxqbus0=";
  };

  doCheck = false; # No tests in pypi source. Did not get tests from GitHub source to work.

  pythonImportsCheck = [ "future_typing" ];

  meta = with lib; {
    description = "Use generic type hints and new union syntax `|` with python 3.6+";
    mainProgram = "future_typing";
    homepage = "https://github.com/PrettyWood/future-typing";
    license = licenses.mit;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
