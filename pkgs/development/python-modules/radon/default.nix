{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, mando
, colorama
, future
, pytest-mock
}:

buildPythonPackage rec {
  pname = "radon";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rubik";
    repo = "radon";
    rev = "v${version}";
    sha256 = "sha256-5gO3Wciqecv6uXC8cwDk/DQIM7fQ9muw/u+z73fV6aY=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  propagatedBuildInputs = [
    mando
    colorama
    future
  ];

  pythonImportsCheck = [
    "radon"
  ];

  meta = with lib; {
    description = "Code Metrics in Python";
    homepage = "https://radon.readthedocs.org/";
    changelog = "https://github.com/rubik/radon/blob/master/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}

