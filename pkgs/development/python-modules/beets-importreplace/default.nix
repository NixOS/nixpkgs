{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  beets-minimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
buildPythonPackage (finalAttrs: {
  pname = "beets-importreplace";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "edgars-supe";
    repo = "beets-importreplace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lTfHuOBFzBM/uN4GCX6btQy0KRDP/tzG0fp9/qppQtw=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    beets-minimal
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beetsplug.importreplace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugin for beets to perform regex replacements during import";
    homepage = "https://github.com/edgars-supe/beets-importreplace";
    maintainers = with lib.maintainers; [ pyrox0 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
