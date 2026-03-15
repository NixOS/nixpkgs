{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysnmp-pyasn1";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pyasn1";
    tag = "v${version}";
    hash = "sha256-W74aWMqGlat+aZfhbP1cTKRz7SomHdGwfK5yJwxgyqI=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyasn1" ];

  meta = {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/pysnmp/pyasn1";
    changelog = "https://github.com/pysnmp/pyasn1/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
