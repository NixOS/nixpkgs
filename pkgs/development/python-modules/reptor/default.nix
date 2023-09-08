{ lib
, asgiref
, buildPythonPackage
, certifi
, charset-normalizer
, deepl
, django
, fetchFromGitHub
, gql
, idna
, markdown-it-py
, mdurl
, pygments
, pytest
, pytestCheckHook
, pythonOlder
, pyyaml
, reptor
, requests
, rich
, setuptools
, sqlparse
, termcolor
, toml
, urllib3
, xmltodict
}:

buildPythonPackage rec {
  pname = "reptor";
  version = "0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Syslifters";
    repo = "reptor";
    rev = "refs/tags/${version}";
    hash = "sha256-Pkz0snlYMd+xn7fJKVdO8M8wA7ABSq8R6i6UN+bwx6Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asgiref
    certifi
    charset-normalizer
    django
    idna
    markdown-it-py
    mdurl
    pygments
    pyyaml
    requests
    rich
    sqlparse
    termcolor
    toml
    urllib3
    xmltodict
  ];

  passthru.optional-dependencies = {
    ghostwriter = [
      gql
    ];
    translate = [
      deepl
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "reptor"
  ];

  disabledTestPaths = [
    # Tests want to use pip install dependencies
    "reptor/plugins/importers/GhostWriter/tests/test_ghostwriter.py"
  ];

  meta = with lib; {
    description = "Module to do automated pentest reporting with SysReptor";
    homepage = "https://github.com/Syslifters/reptor";
    changelog = "https://github.com/Syslifters/reptor/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
