{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pip,
  typing-extensions,
  platformdirs,
  pydantic,
  pydantic-core,
  pyinfra,
  ansible,
  ansible-core,
  ansible-runner,
  pytestCheckHook,
  django,
  django-stubs,
  django-admin-data-views,
  django-pydantic-field,
  django-jsonform,
}:

buildPythonPackage rec {
  pname = "abx-pkg";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "abx-pkg";
    rev = "refs/tags/v${version}";
    hash = "sha256-CBHNDXhoiwLRLUJzavV7A3eG5/qfAta1x/b27IyoFIQ=";
  };

  pythonRelaxDeps = [ "pip" ];

  build-system = [
    hatchling
  ];

  dependencies = [
    pip
    typing-extensions
    platformdirs
    pydantic
    pydantic-core
  ];

  optional-dependencies = {
    pyinfra = [ pyinfra ];
    ansible = [
      ansible
      ansible-core
      ansible-runner
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    django
    django-stubs
    django-admin-data-views
    django-pydantic-field
    django-jsonform
  ];

  pytestFlagsArray = [ "tests.py" ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "abx_pkg" ];

  meta = {
    changelog = "https://github.com/ArchiveBox/pydantic-pkgr/releases/tag/v${version}";
    description = "Modern Python library for managing system dependencies with package managers like apt, brew, pip, npm, etc.";
    homepage = "https://github.com/ArchiveBox/pydantic-pkgr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
