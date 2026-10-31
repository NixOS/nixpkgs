{
  lib,
  buildPythonPackage,
  chameleon,
  click,
  fetchFromGitHub,
  polib,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "lingua";
  version = "4.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wichert";
    repo = "lingua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C/F676BoiZDNy8BhP0I2Z2Bh5gdMztyqo4zOL88Jw9Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.5,<0.11.0" "uv_build"

    substituteInPlace src/lingua/extract.py \
      --replace-fail SafeConfigParser ConfigParser
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    click
    polib
  ];

  nativeCheckInputs = [
    chameleon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lingua" ];

  meta = {
    description = "Translation toolset";
    homepage = "https://github.com/wichert/lingua";
    changelog = "https://github.com/wichert/lingua/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ np ];
  };
})
