{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  nix-update-script,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "inflate64";
    tag = "v${version}";
    hash = "sha256-Ytz+QbztpNm7cbUqWu0rlYzk3Q3qyg0evikCV22+mXo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "inflate64"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Compress and decompress with Enhanced Deflate compression algorithm";
    homepage = "https://codeberg.org/miurahr/inflate64";
    changelog = "https://codeberg.org/miurahr/inflate64/src/tag/v${version}/docs/Changelog.rst#v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };

}
