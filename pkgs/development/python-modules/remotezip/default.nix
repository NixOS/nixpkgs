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
  version = "0.12.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gtsystem";
    repo = "python-remotezip";
    # upstream does not tag releases, determined with git blame
    # pypi archive lacks files for tests
    rev = "da62e115bdb2071ad08a8c91f7ae48f2c1827e0c";
    hash = "sha256-su4dlV8KZuewf/yGdTnGHK9hNLHwGe10ditmFcne4Us=";
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
