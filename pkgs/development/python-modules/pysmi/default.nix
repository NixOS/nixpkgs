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
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "pysmi";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysmi";
    tag = "v${version}";
    hash = "sha256-GyG3J6qntEIszXrm1t623+x1cYbhJLbTEQl6N2h2LA0=";
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

  meta = with lib; {
    description = "SNMP MIB parser";
    homepage = "https://github.com/lextudio/pysmi";
    changelog = "https://github.com/lextudio/pysmi/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
