{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, six
}:

buildPythonPackage {
  pname = "mando";
  version = "0.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rubik";
    repo = "mando";

    # this rev contains a fix for newer versions of python (3.8+), but is still tagged 0.6.4
    rev = "460c2ed296f04530a84d39c1e547b143f11b7580";
    sha256 = "sha256-Ge73kNrE5PeiFKy1lxOC3OS/0b5HWfGz95ZuLcMJCkI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # these tests are disabled since they are only docstring tests and appear to be broken upstream
  disabledTests = [
    "test_google_docstring_help"
    "test_numpy_docstring_help"
  ];

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [
    "mando"
  ];

  meta = with lib; {
    description = "Create Python CLI apps with little to no effort at all";
    homepage = "https://mando.readthedocs.org/";
    changelog = "https://github.com/rubik/mando/blob/master/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}

