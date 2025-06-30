{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pycryptodome,
  py-datastruct,
  pyserial,
}:

buildPythonPackage rec {
  pname = "bk7231tools";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tuya-cloudcutter";
    repo = "bk7231tools";
    tag = "v${version}";
    hash = "sha256-Ag63VNBSKEPDaxhS40SVB8rKIJRS1IsrZ9wSD0FglSU=";
  };

  pythonRelaxDeps = [
    "pycryptodome"
    "py-datastruct"
    "pyserial"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    pycryptodome
    py-datastruct
    pyserial
  ];

  pythonImportsCheck = [ "bk7231tools" ];

  meta = {
    description = "Tools to interact with and analyze artifacts for BK7231 MCUs";
    homepage = "https://github.com/tuya-cloudcutter/bk7231tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mevatron ];
    mainProgram = "bk7231tools";
  };
}
