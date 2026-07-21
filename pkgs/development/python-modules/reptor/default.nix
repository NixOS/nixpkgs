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

buildPythonPackage (finalAttrs: {
  pname = "reptor";
  version = "0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syslifters";
    repo = "reptor";
    tag = finalAttrs.version;
    hash = "sha256-L4w9QWyj+NyImQKLKWfdosLl+qytPqa+eyRw6p/4GgA=";
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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "reptor" ];

  disabledTestMarks = [
    # Tests need network access
    "integration"
  ];

  meta = {
    description = "Module to do automated pentest reporting with SysReptor";
    homepage = "https://github.com/Syslifters/reptor";
    changelog = "https://github.com/Syslifters/reptor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "reptor";
  };
})
