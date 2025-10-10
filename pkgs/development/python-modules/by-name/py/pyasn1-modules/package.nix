{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyasn1,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyasn1";
    repo = "pyasn1-modules";
    tag = "v${version}";
    hash = "sha256-jpMIxQ4BJ7MY3cV276sVJv+3M/MMFKRIoL2m2QJFxRY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyasn1 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyasn1_modules" ];

  meta = {
    description = "Collection of ASN.1-based protocols modules";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/pyasn1/pyasn1-modules/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
