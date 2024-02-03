{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, tabulate
, pytestCheckHook
, requests-mock
}:

buildPythonPackage {
  pname = "remotezip";
  version = "0.12.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gtsystem";
    repo = "python-remotezip";
    # upstream does not tag releases, determined with git blame
    # pypi archive lacks files for tests
    rev = "3723724d6d877d3166d52f4528ffa7bd5bf6627f";
    hash = "sha256-iYxHW8RdLFrpjkcEvpfF/NWBnw7Dd5cx2ghpof2XFn4=";
  };

  propagatedBuildInputs = [
    requests
    tabulate
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    requests-mock
  ];

  pythonImportsCheck = [
    "remotezip"
  ];

  meta = with lib; {
    description = "Python module to access single members of a zip archive without downloading the full content";
    homepage = "https://github.com/gtsystem/python-remotezip";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
