{
  lib,
  buildPythonPackage,
  certifi,
  cvss,
  deepl,
  django,
  fetchFromGitHub,
  gql,
  pytestCheckHook,
  pyyaml,
  requests,
  rich,
  setuptools,
  sqlparse,
  termcolor,
  tomli-w,
  tomli,
  tomlkit,
  urllib3,
  writableTmpDirAsHomeHook,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "reptor";
  version = "0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syslifters";
    repo = "reptor";
    tag = version;
    hash = "sha256-AbrfQJQvKXpV4FrhkGZOLYX3px9dzr9whJZwzR/7UYM=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    certifi
    cvss
    django
    pyyaml
    requests
    rich
    termcolor
    tomli
    tomli-w
    tomlkit
    urllib3
    xmltodict
  ];

  optional-dependencies = {
    ghostwriter = [ gql ] ++ gql.optional-dependencies.aiohttp;
    translate = [ deepl ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "reptor" ];

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
    changelog = "https://github.com/Syslifters/reptor/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "reptor";
  };
}
