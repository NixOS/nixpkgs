{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools
}:

buildPythonPackage rec {
  version = "2.4";
  pname = "crc32c";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rWR2MtTLhqqvgdqEyevg/i8ZHM3OU1bJb27JkBx1J3w=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
