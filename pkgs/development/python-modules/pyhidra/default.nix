{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jpype1,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyhidra";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dod-cyber-crime-center";
    repo = "pyhidra";
    tag = version;
    hash = "sha256-8xouU+S7Apy1ySIlvOLPerTApqKy/MNdl9vuBdt+9Vk=";
  };

  build-system = [ setuptools ];

  dependencies = [ jpype1 ];

  pythonImportsCheck = [ "pyhidra" ];

  meta = {
    description = "Provides direct access to the Ghidra API within a native CPython interpreter using jpype";
    homepage = "https://github.com/dod-cyber-crime-center/pyhidra";
    changelog = "https://github.com/dod-cyber-crime-center/pyhidra/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
