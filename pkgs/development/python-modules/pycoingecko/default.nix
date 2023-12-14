{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, requests, setuptools
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pycoingecko";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3MCFIsFg6IvR3rULurOQvjPc6Hq7EKkc5gE9Fb+FnBI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycoingecko" ];

  meta = with lib; {
    changelog = "https://github.com/man-c/pycoingecko/releases/tag/${version}";
    description = "Python wrapper for the CoinGecko API";
    homepage = "https://github.com/man-c/pycoingecko";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
