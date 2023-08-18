{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyjwt
, ratelimit
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyflume";
  version = "0.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ChrisMandich";
    repo = "PyFlume";
    rev = "refs/tags/v${version}";
    hash = "sha256-wmaOOM8y7LthEgf3Uyv1N4ODviPGSlIQejC01IlhaJw=";
  };

  propagatedBuildInputs = [
    pyjwt
    ratelimit
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyflume"
  ];

  meta = with lib; {
    description = "Python module to work with Flume sensors";
    homepage = "https://github.com/ChrisMandich/PyFlume";
    changelog = "https://github.com/ChrisMandich/PyFlume/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
