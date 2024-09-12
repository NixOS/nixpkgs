{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  ply,
  poetry-core,
  pysmi,
  pysnmp,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  version = "1.5.0";
  pname = "pysmi";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lextudio";
    repo = "pysmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-9yAsseMI50RhVeyFvuTo/pN9ftrvvUWYCacy2v3VVT8=";
  };

  build-system = [ poetry-core ];

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
