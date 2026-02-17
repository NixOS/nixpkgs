{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  jinja2,
  ply,
  pysmi,
  pysnmp,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmi";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TpDrsBGym07JPIcnytyWI7Ebx9RR+7Ia36zOzWMWqPM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    ply
    jinja2
    requests
  ];

  nativeCheckInputs = [
    pysnmp
    pytestCheckHook
  ];

  # Tests require pysnmp, which in turn requires pysmi => infinite recursion
  doCheck = false;

  pythonImportsCheck = [ "pysmi" ];

  passthru.tests.pytest = pysmi.overridePythonAttrs { doCheck = true; };

  meta = {
    description = "SNMP MIB parser";
    homepage = "https://github.com/lextudio/pysmi";
    changelog = "https://github.com/lextudio/pysmi/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
