{ lib
, asgiref
, buildPythonPackage
, certifi
, charset-normalizer
, cvss
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
, pythonRelaxDepsHook
, pyyaml
, reptor
, requests
, rich
, setuptools
, sqlparse
, termcolor
, tomli
, tomli-w
, tomlkit
, urllib3
, xmltodict
}:

buildPythonPackage rec {
  pname = "reptor";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Syslifters";
    repo = "reptor";
    rev = "refs/tags/${version}";
    hash = "sha256-CjTedIl7ZkSFfKKhHmCadTd7zdz3gP7Q4uCscv5An38=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    asgiref
    certifi
    charset-normalizer
    cvss
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
    tomli
    tomlkit
    tomli-w
    urllib3
    xmltodict
  ];

  passthru.optional-dependencies = {
    ghostwriter = [
      gql
    ] ++ gql.optional-dependencies.aiohttp;
    translate = [
      deepl
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "reptor"
  ];

  disabledTestPaths = [
    # Tests want to use pip install dependencies
    "reptor/plugins/importers/GhostWriter/tests/test_ghostwriter.py"
  ];

  disabledTests = [
    # Tests need network access
    "TestDummy"
    "TestIntegration"

  ];

  meta = with lib; {
    description = "Module to do automated pentest reporting with SysReptor";
    homepage = "https://github.com/Syslifters/reptor";
    changelog = "https://github.com/Syslifters/reptor/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
