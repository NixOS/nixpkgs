{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-zabbix";
  version = "1.1.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adubkov";
    repo = "py-zabbix";
    rev = "refs/tags/${version}";
    hash = "sha256-aPQc188pszfDQvNtsGYlRLHS5CG5VyqptSoe4/GJVvE=";
  };

  patches = [
    # Remove Python2 comp, https://github.com/adubkov/py-zabbix/pull/154
    (fetchpatch {
      name = "no-more-py2.patch";
      url = "https://github.com/adubkov/py-zabbix/commit/8deedb860f52870fbeacc54a40341520702341e2.patch";
      hash = "sha256-Af7pnCZIObC0ZQLaamBK1pTAVAFs/Mh7+og5jAKqk4s=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyzabbix" ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # AttributeError: 'RawConfigParser' object has no attribute 'readfp'
    "config"
  ];

  meta = with lib; {
    description = "Python module to interact with Zabbix";
    homepage = "https://github.com/adubkov/py-zabbix";
    changelog = "https://github.com/adubkov/py-zabbix/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
