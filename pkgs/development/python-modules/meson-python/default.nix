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
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-mVnRmKpptX/P01SjRRjG95W3gac+0GVvTQFmAWDMJVM=";
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

  # meson-python respectes MACOSX_DEPLOYMENT_TARGET, but compares it with the
  # actual platform version during tests, which mismatches.
  # https://github.com/mesonbuild/meson-python/issues/760
  # FIXME: drop in 0.19.0
  preCheck =
    if stdenv.hostPlatform.isDarwin then
      ''
        unset MACOSX_DEPLOYMENT_TARGET
      ''
    else
      null;

  setupHooks = [ ./add-build-flags.sh ];

  meta = {
    changelog = "https://github.com/mesonbuild/meson-python/blob/${version}/CHANGELOG.rst";
    description = "Meson Python build backend (PEP 517)";
    homepage = "https://github.com/mesonbuild/meson-python";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ doronbehar ];
    teams = [ lib.teams.python ];
  };
}
