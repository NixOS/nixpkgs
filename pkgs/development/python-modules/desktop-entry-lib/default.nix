{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromCodeberg,
  setuptools,
  jeepney,
  pyfakefs,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "desktop-entry-lib";
  version = "5.0";
  pyproject = true;

  # We could use fetchPypi, but then the tests won't run
  src = fetchFromCodeberg {
    owner = "JakobDev";
    repo = "desktop-entry-lib";
    rev = version;
    hash = "sha256-RRob8VFqx/UZrf/dIm9c+mfJm9VK0XCPdvdUnTEm2DQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    jeepney
    pyfakefs
    pytest-cov
  ];

  # pytest 9 has subtests built in; the 5.0 tests still use the
  # pytest-subtests module, which no longer exists in nixpkgs.
  postPatch = ''
    substituteInPlace tests/test_action.py tests/test_collection.py tests/test_entry.py tests/test_portal.py \
      --replace-fail 'import pytest_subtests' "" \
      --replace-fail 'pytest_subtests.SubTests' 'pytest.Subtests'
  '';

  # pyfakefs interferes with pytest's output capture on Python 3.14, and
  # coverage cannot write its SQLite file inside pyfakefs' fake filesystem.
  pytestFlags = [
    "--capture=no"
    "--no-cov"
  ];

  pythonImportsCheck = [ "desktop_entry_lib" ];

  meta = {
    description = "Allows reading and writing .desktop files according to the Desktop Entry Specification";
    homepage = "https://codeberg.org/JakobDev/desktop-entry-lib";
    changelog = "https://codeberg.org/JakobDev/desktop-entry-lib/releases/tag/${version}";
    license = lib.licenses.bsd2;
  };
}
