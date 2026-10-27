{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libcec,
  pytestCheckHook,
  setuptools,
  runCommand,
  writers,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycec";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "konikvranik";
    repo = "pycec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KQyHjAvHWeHFqcFHFJxDOPwWuVcFAN2wVdz9a77dzU=";
  };

  patches = [
    # https://github.com/konikvranik/pyCEC/pull/84
    ./python-3.14-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ libcec ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "cec"
    "pycec"
  ];

  # Ideally, failures to propagate cec as an implicit dependency of
  # pycec would be caught by pythonImportsCheckPhase, but the way it's
  # currently designed to read the ambient $PYTHONPATH instead of
  # deriving $PYTHONPATH from $out/nix-support/propagated-build-inputs
  # may lead to false positives.
  #
  # See https://github.com/NixOS/nixpkgs/pull/573303
  passthru.tests.propagate-cec = runCommand "test-propagate-cec" { } ''
    ${writers.writePython3 "test-propagate-cec.py" {
      libraries = [ finalAttrs.finalPackage ];
      doCheck = false;
    } "import cec"}

    touch "$out"
  '';

  meta = {
    description = "Python modules to access HDMI CEC devices";
    mainProgram = "pycec";
    homepage = "https://github.com/konikvranik/pycec/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
