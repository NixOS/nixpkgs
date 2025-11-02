{
  lib,
  buildPythonPackage,
  fetchFromSourcehut,
  docutils,
  semver,
  setuptools,
  testscenarios,
  testtools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "changelog-chug";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~bignose";
    repo = "changelog-chug";
    rev = "release/${version}";
    hash = "sha256-SPwFkmRQMpdsVmzZE4mB2J9wsfvE1K21QDkOQ2XPlow=";
    # HACK: sourcehut can't generate tarballs from tags with slashes properly,
    # so force using git clone.
    # See: https://todo.sr.ht/~sircmpwn/git.sr.ht/323
    fetchSubmodules = true;
  };

  build-system = [
    docutils
    semver
    setuptools
  ];

  dependencies = [
    docutils
    semver
  ];

  nativeCheckInputs = [
    testscenarios
    testtools
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "chug"
  ];

  meta = {
    description = "Changelog document parser";
    homepage = "https://git.sr.ht/~bignose/changelog-chug";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
}
