{ lib
, buildPythonPackage
, fetchFromGitHub
, nixosTests
, fixtures
, pytestCheckHook
, pyxdg
, requests
, requests-mock
, sphinx
, tomli
, urllib3
}:

buildPythonPackage rec {
  pname = "podman-py";
  version = "4.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-py";
    rev = "v${version}";
    hash = "sha256-xG5a+l0pAFPe9lv7aOCQE7sAXEEUhyylmpBMIK7ymjw=";
  };

  propagatedBuildInputs = [
    pyxdg
    requests
    sphinx
    tomli
    urllib3
  ];

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # Tests require active podman service
    "podman/tests/integration"
  ];

  pythonImportsCheck = [
    "podman"
  ];

  passthru.tests = {
    inherit (nixosTests) podman-py;
  };

  meta = with lib; {
    description = "This python package is a library of bindings to use the RESTful API of Podman";
    homepage = "https://github.com/containers/podman-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
