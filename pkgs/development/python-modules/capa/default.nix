{
  lib,
  buildPythonPackage,
  colorama,
  deptry,
  dncil,
  dnfile,
  fetchFromGitHub,
  humanize,
  ida-netnode,
  ida-settings,
  jschema-to-python,
  msgspec,
  mypy-protobuf,
  mypy,
  networkx,
  pefile,
  protobuf,
  psutil,
  pydantic,
  pyelftools,
  pyghidra,
  pygithub,
  pytest-instafail,
  pytest-sugar,
  pytestCheckHook,
  python-flirt,
  pyyaml,
  requests,
  rich,
  ruamel-yaml,
  sarif-om,
  setuptools-scm,
  setuptools,
  stix2,
  types-colorama,
  types-protobuf,
  types-psutil,
  types-pyyaml,
  types-requests,
  viv-utils,
  vivisect,
  writableTmpDirAsHomeHook,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "capa";
  version = "9.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "capa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h9ML+TJe9NprBEy4W7XKahmUTM0d4vY0zIFs6MxYzZ8=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    colorama
    dncil
    dnfile
    humanize
    ida-netnode
    ida-settings
    msgspec
    networkx
    pefile
    protobuf
    pydantic
    pyelftools
    python-flirt
    pyyaml
    rich
    ruamel-yaml
    viv-utils
    vivisect
    xmltodict
  ];

  optional-dependencies = {
    ghidra = [ pyghidra ];
    scripts = [
      jschema-to-python
      psutil
      requests
      sarif-om
      stix2
    ];
  };

  nativeCheckInputs = [
    pygithub
    pytestCheckHook
    pytest-instafail
    pytest-sugar
    types-colorama
    types-protobuf
    types-psutil
    types-pyyaml
    types-requests
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "capa" ];

  disabledTests = [
    # AssertionError
    "test_is_dev_environment"
    "test_rule_cache_dev_environment"
    "test_scripts"
    "test_binexport_scripts"
  ];

  meta = {
    description = "Tool to identify capabilities in executable files";
    homepage = "https://github.com/mandiant/capa";
    changelog = "https://github.com/mandiant/capa/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "capa";
  };
})
