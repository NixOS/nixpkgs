{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-fZ2bPPjBK/H2jMI4S3EhvWJaNl4tK7HstxcHSAkoFW4=";
  };

  patches = [
    (fetchpatch {
      name = "0001-adapt-test-to-latest-mypy.patch";
      url = "https://github.com/python-lsp/pylsp-mypy/commit/99cf687798464f810b128881dbbec82aa5353e04.patch";
      sha256 = "sha256-wLaGMaW/gTab2fX7zGnemLQQNDWxBURYb7VsgEas61Y=";
    })
  ];

  propagatedBuildInputs = [
    mypy
    python-lsp-server
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylsp_mypy"
  ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = with lib; {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
