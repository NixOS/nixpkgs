{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  copier,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "copier-template-extensions";
  version = "0.3.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "copier-org";
    repo = "copier-template-extensions";
    tag = finalAttrs.version;
    hash = "sha256-EiepLuCznF6eaZHRVbx5YqmqnRoTg5dzLR4GBVq3wUg=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    copier
  ];

  pythonImportsCheck = [
    "copier_template_extensions"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Special Jinja2 extension for Copier that allows to load extensions using file paths relative to the template root instead of Python dotted paths";
    homepage = "https://github.com/copier-org/copier-template-extensions";
    changelog = "https://github.com/copier-org/copier-template-extensions/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
})
