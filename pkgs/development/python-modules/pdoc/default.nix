{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, jinja2
, pygments
, markupsafe
, astunparse
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "pdoc";
<<<<<<< HEAD
  version = "14.0.0";
  disabled = pythonOlder "3.8";

  format = "pyproject";

=======
  version = "13.0.0";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  # the Pypi version does not include tests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rMHp0diXvWIOyucuTAXO/IOljKhDYOZKtkih5+rUJCM=";
=======
    hash = "sha256-UzUAprvBimk2POi0QZdFuRWEeGDp+MLmdUYR0UiIubs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jinja2
    pygments
    markupsafe
  ] ++ lib.optional (pythonOlder "3.9") astunparse;

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];
  disabledTestPaths = [
<<<<<<< HEAD
    # "test_snapshots" tries to match generated output against stored snapshots,
    # which are highly sensitive to dep versions.
=======
    # "test_snapshots" tries to match generated output against stored snapshots.
    # They are highly sensitive dep versions, which we unlike upstream do not pin.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test/test_snapshot.py"
  ];

  pytestFlagsArray = [
<<<<<<< HEAD
    ''-m "not slow"'' # skip slow tests
=======
    ''-m "not slow"'' # skip tests marked slow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pdoc" ];

  meta = with lib; {
    changelog = "https://github.com/mitmproxy/pdoc/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    license = licenses.unlicense;
    maintainers = with maintainers; [ pbsds ];
  };
}
