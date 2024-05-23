{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "2.3.post0";
  pname = "crc32c";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lPEojWeAhfWpGR+k+Tuo4n68iZOk7lUDxjWXj5vN4I0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
