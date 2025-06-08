{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pythonOlder,

  # build-system, dependencies
  meson,
  ninja,
  pyproject-metadata,
  tomli,

  # tests
  cython,
  git,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "meson-python";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "meson_python";
    hash = "sha256-xWqZ7J32aaQGYv5GlgMhr25LFBBsFNsihwnBYo4jhI0=";
  };

  patches = [
    (fetchpatch {
      # TODO: Remove in 0.19.0
      url = "https://github.com/mesonbuild/meson-python/commit/1e69e7a23f2b24d688dc4220e93de6f0e2bcf9d2.patch";
      hash = "sha256-FC2ll/OrLV1R0CDB6UkrknVASJQ7rSU+sApdAk75x44=";
    })
  ];

  build-system = [
    meson
    ninja
    pyproject-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    meson
    ninja
    pyproject-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    cython
    git
    pytestCheckHook
    pytest-mock
  ];

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
