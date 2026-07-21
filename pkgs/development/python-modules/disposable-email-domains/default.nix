{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "disposable-email-domains";
  version = "0.0.216";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    pname = "disposable_email_domains";
    inherit (finalAttrs) version;
    hash = "sha256-b9qSbIJ3wrINFnfhkzKu60WX7w6l860jjZ/klkeIhY4=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "disposable_email_domains" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Set of disposable email domains";
    homepage = "https://github.com/disposable-email-domains/disposable-email-domains";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
