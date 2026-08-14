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
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-rIofdyT9XsWPViBbcNyLXxLBFMUeKxLE95axo8Ydvn8=";
  };

  build-system = [ setuptools ];

  patches = [
    ./python3-integer-division.patch
  ];

  postPatch = ''
    for test in tests/*.py; do
      if grep -q '^import pyemf$' "$test"; then
        substituteInPlace "$test" \
          --replace-fail "import pyemf" "import pyemf3 as pyemf"
      fi
    done
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    for expected in tests/orig/*.emf; do
      testName="$(basename "$expected" .emf)"

      python "tests/$testName.py"
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

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "pyemf3" ];

  meta = with lib; {
    description = "Pure Python Enhanced Metafile Library";
    homepage = "https://github.com/jeremysanders/pyemf3/";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abkein ];
  };
})
