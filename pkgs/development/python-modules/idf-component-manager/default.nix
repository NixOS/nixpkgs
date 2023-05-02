{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, cachecontrol
, click
, colorama
, contextlib2
, future
, packaging
, pyyaml
, requests
, requests-file
, requests-toolbelt
, schema
, six
, tqdm

# tests
, git
, pytest-mock
, pytestCheckHook
, vcrpy
}:

let
  pname = "idf-component-manager";
  version = "1.2.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "idf-component-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-4ecS5ItUFWPOFKqbF5OmGovDaNwJgcjHZP8c4crFMeA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cachecontrol
    click
    colorama
    contextlib2
    future
    packaging
    pyyaml
    requests
    requests-file
    requests-toolbelt
    schema
    six
    tqdm
  ]
  ++ cachecontrol.optional-dependencies.filecache;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    git
    pytest-mock
    pytestCheckHook
    vcrpy
  ];

  disabledTestPaths = [
    # compote is unpackaged
    "tests/cli/test_compote.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/espressif/idf-component-manager/releases/tag/v${version}";
    description = "Tool for installing ESP-IDF components";
    license = licenses.asl20;
    homepage = "https://github.com/espressif/idf-component-manager";
    maintainers = with maintainers; [ hexa ];
  };
}
