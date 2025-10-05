{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyring-buffer";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyring-buffer";
    tag = "v${version}";
    hash = "sha256-s0iIcY2cwTbOMrpw14uAYfeAl/MOJTLfZbJr+tmTM6U=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyring_buffer" ];

  meta = with lib; {
    description = "Pure Python ring buffer for bytes";
    homepage = "https://github.com/rhasspy/pyring-buffer";
    changelog = "https://github.com/rhasspy/pyring-buffer/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
