{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitLab
, pythonOlder
, diff-cover
, pytestCheckHook
, setuptools
, setuptools-scm
, git
, virtualenv
}:

buildPythonPackage rec {
  pname = "git-version-info";
  version = "0.6.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "git_version_info";
    inherit version;
    hash = "sha256-5o2MM3Y+0K8aY6KdRme9j3ZKMCuYNl2URvGtpbDjNjg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInput = [
    git
  ];

  nativeCheckInputs = [
    diff-cover
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "version_info"
  ];

  checkPhase = ''
    runHook preCheck
    pytest -k "not test_calling_git"
    runHook postCheck
  '';

  meta = with lib; {
    description = "A very simple package for getting the git hash of the current repository and
adding it to a matplotlib plot.";
    homepage = "https://gitlab.com/charlesbaynham/version_info";
    license = licenses.mit;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
