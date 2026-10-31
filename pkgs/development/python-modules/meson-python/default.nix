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
  version = "0.22.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-UsiGKLDlZxWS3CMGYT+19vNhX9JN7wWbmJTxQ7f5oTk=";
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

  # For the ld-wrapper to work, we need to use pure rpaths.
  # Ones under $out will do (even though there's no native library in it)
  preCheck = ''
    substituteInPlace tests/test_wheel.py \
      --replace-fail /usr/lib/test-ldflags "$out/lib/test-ldflags" \
      --replace-fail /usr/local/lib "$out/lib"
    substituteInPlace tests/packages/purelib-and-platlib/meson.build \
      --replace-fail /usr/local/lib "$out/lib"
  '';

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
