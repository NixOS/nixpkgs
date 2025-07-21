{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crc32c";
  version = "2.7.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = "crc32c";
    tag = "v${version}";
    hash = "sha256-WBFiAbdzV719vPdZkRGei2+Y33RroMZ7FeQmWo/OfE0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    changelog = "https://github.com/ICRAR/crc32c/blob/master/CHANGELOG.md";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
