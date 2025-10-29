{
  lib,
  buildPythonPackage,
  certifi,
  cvss,
  deepl,
  django,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syslifters";
    repo = "reptor";
    tag = version;
    hash = "sha256-nNG4rQHloOqcPZPnvw3hbw0+wCbB2XAdQ5/XnJtCHnE=";
  };

  patches = [
    # https://github.com/Syslifters/reptor/pull/221
    (fetchpatch {
      url = "https://github.com/Syslifters/reptor/commit/0fc43c246e2f99aaac9e78af818f360a3a951980.patch";
      hash = "sha256-eakbI7hMJdshD0OA6n7dEO4+qPB21sYl09uZgepiWu0=";
    })
  ];

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

  disabledTestMarks = [
    # Tests need network access
    "integration"
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
