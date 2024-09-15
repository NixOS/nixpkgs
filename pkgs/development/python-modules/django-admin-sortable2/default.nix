{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-admin-sortable2";
  version = "2.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jrief";
    repo = "django-admin-sortable2";
    rev = "refs/tags/${version}";
    hash = "sha256-ZXaLe6H6il27DXMwclKR4iRGyus6zyYt3rNWRsLPHSU=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  pythonImportsCheck = [ "adminsortable2" ];

  # Tests are very slow (end-to-end with playwright)
  doCheck = false;

  meta = {
    description = "Generic drag-and-drop ordering for objects in the Django admin interface";
    homepage = "https://github.com/jrief/django-admin-sortable2";
    changelog = "https://github.com/jrief/django-admin-sortable2/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
