{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "pyemf3";
  version = "3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeremysanders";
    repo = "pyemf3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rIofdyT9XsWPViBbcNyLXxLBFMUeKxLE95axo8Ydvn8=";
  };

  build-system = [ setuptools ];

  patches = [
    # https://github.com/jeremysanders/pyemf3/pull/5
    ./correct-roundrect.patch
    # https://github.com/jeremysanders/pyemf3/pull/6
    ./fix-integer-division.patch
    # https://github.com/jeremysanders/pyemf3/pull/7
    ./fix-tests.patch
    # https://github.com/jeremysanders/pyemf3/pull/8
    # Use EMF's little-endian byte order on every architecture.
    ./portable-serialization.patch
  ];

  checkPhase = ''
    runHook preCheck

    pushd tests

    for expected in orig/*.emf; do
      testName="$(basename "$expected" .emf)"

      python "$testName.py"
      cmp "$testName.emf" "$expected"

      python - "$expected" "$testName.roundtrip.emf" <<'PY'
    import sys
    import pyemf3

    metafile = pyemf3.EMF()
    metafile.load(sys.argv[1])
    metafile.save(sys.argv[2])
    PY
      cmp "$testName.roundtrip.emf" "$expected"
    done

    python test-endianness.py

    popd

    runHook postCheck
  '';

  pythonImportsCheck = [ "pyemf3" ];

  meta = {
    description = "Pure Python Enhanced Metafile Library";
    homepage = "https://github.com/jeremysanders/pyemf3/";
    changelog = "https://raw.githubusercontent.com/jeremysanders/pyemf3/refs/tags/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ abkein ];
  };
})
