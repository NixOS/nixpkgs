{ lib
, blockdiag
, buildPythonPackage
, fetchFromGitHub
, pynose
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "actdiag";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "actdiag";
    rev = "refs/tags/${version}";
    hash = "sha256-WmprkHOgvlsOIg8H77P7fzEqxGnj6xaL7Df7urRkg3o=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    blockdiag
  ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/actdiag/tests/"
  ];

  disabledTests = [
    # AttributeError: 'TestRstDirectives' object has no attribute 'assertRegexpMatches'
    "svg"
    "noviewbox"
  ];

  pythonImportsCheck = [
    "actdiag"
  ];

  meta = with lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/actdiag/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "actdiag";
    platforms = platforms.unix;
  };
}
