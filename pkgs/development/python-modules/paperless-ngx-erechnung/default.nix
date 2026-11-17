{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lxml,
  pikepdf,
  pypdfium2,
  saxonche,
  pillow,
  fop,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "paperless-ngx-erechnung";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitbetterde";
    repo = "paperless-ngx-erechnung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cdi3dFloqN1XvMaojdrU39Z9kskEabxMgK5KklBazsU=";
  };

  postPatch = ''
    substituteInPlace src/paperless_ngx_erechnung/rendering.py \
      --replace-fail 'shutil.which("fop")' '"${lib.getExe fop}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    lxml
    pikepdf
    pypdfium2
    saxonche
    pillow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "paperless_ngx_erechnung" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XRechnung and ZUGFeRD/Factur-X parser plugin for Paperless-ngx";
    homepage = "https://github.com/bitbetterde/paperless-ngx-erechnung";
    changelog = "https://github.com/bitbetterde/paperless-ngx-erechnung/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
