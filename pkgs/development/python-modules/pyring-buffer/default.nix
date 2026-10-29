{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyring-buffer";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyring-buffer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-woFFPb+NwYTsQ9YRETHmEnt9KxvNql8NDOBg5Rp0UGE=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pyring_buffer" ];

  meta = {
    description = "Pure Python ring buffer for bytes";
    homepage = "https://github.com/rhasspy/pyring-buffer";
    changelog = "https://github.com/rhasspy/pyring-buffer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
