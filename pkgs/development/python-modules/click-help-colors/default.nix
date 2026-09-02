{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  click,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-help-colors";
  version = "0.9.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "click-help-colors";
    inherit (finalAttrs) version;
    hash = "sha256-9Mq+Us9VApm4iI9PLuTF81msJ+M7z+TWHbR3haXMk2w=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "click_help_colors" ];

  meta = {
    description = "Colorization of help messages in Click";
    homepage = "https://github.com/click-contrib/click-help-colors";
    changelog = "https://github.com/click-contrib/click-help-colors/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
