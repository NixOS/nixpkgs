{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "find-libpython";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ktbarrett";
    repo = "find_libpython";
    rev = "refs/tags/v${version}";
    hash = "sha256-DBBAgfYQ4UBFn5Osb1kpVBWbrZVBAvcVGQ/J4rJO/rQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "find_libpython"
  ];

  meta = with lib; {
    description = "Finds the libpython associated with your environment, wherever it may be hiding";
    changelog = "https://github.com/ktbarrett/find_libpython/releases/tag/v${version}";
    homepage = "https://github.com/ktbarrett/find_libpython";
    license = licenses.mit;
    maintainers = with maintainers; [ jleightcap ];
  };
}
