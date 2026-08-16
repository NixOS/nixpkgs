{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system, dependencies
  meson,
  ninja,
  pyproject-metadata,

  # tests
  cmake,
  cython,
  gitMinimal,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-bZcmrmzTfiLyEMdLNkswGApowgRC6X/wnzxWakFK9zg=";
  };

  build-system = [
    meson
    ninja
    pyproject-metadata
  ];

  dependencies = [
    meson
    ninja
    pyproject-metadata
  ];

  nativeCheckInputs = [
    cmake
    cython
    gitMinimal
    pytestCheckHook
    pytest-mock
  ];

  dontUseCmakeConfigure = true;

  setupHooks = [ ./add-build-flags.sh ];

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    teams = [ lib.teams.python ];
  };
}
