{
  lib,
  buildPythonPackage,
  dj-database-url,
  dj-email-url,
  django-cache-url,
  fetchFromGitHub,
  flit-core,
  marshmallow,
  pytestCheckHook,
  python-dotenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "environs";
  version = "14.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "environs";
    tag = finalAttrs.version;
    hash = "sha256-TX8C3KIuvAkC+ArGFz9FXyqxd9pfTgmMqnLuYNIlA4o=";
  };

  build-system = [ flit-core ];

  dependencies = [
    marshmallow
    python-dotenv
  ];

  nativeCheckInputs = [
    dj-database-url
    dj-email-url
    django-cache-url
    pytestCheckHook
  ];

  pythonImportsCheck = [ "environs" ];

  meta = {
    description = "Python module for environment variable parsing";
    homepage = "https://github.com/sloria/environs";
    changelog = "https://github.com/sloria/environs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
