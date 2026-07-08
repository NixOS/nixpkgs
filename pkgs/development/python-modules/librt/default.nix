{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mypy-extensions,
  python,
  pytest,
  stdenv,
}:

buildPythonPackage rec {
  pname = "librt";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "librt";
    tag = "v${version}";
    hash = "sha256-y9z1EdrZRiDtT8cxz/Ex/f6B/RfjnAXdGf7tM+77HGg=";
  };

  # https://github.com/mypyc/librt/blob/v0.7.8/.github/workflows/buildwheels.yml#L90-L93
  postPatch = ''
    cp -rv lib-rt/* .

    # build_setup.py patches CCompiler.spawn to inject architecture-specific
    # SIMD flags based on platform.machine() (which returns the build arch instead
    # of the target arch). When cross-compiling, this causes the compiler to abort
    # with "unrecognized command-line option" errors.
    #
    # The patch below forces the use of the target architecture, in order
    # to keep SIMD flags for x86_64 targets while avoiding them elsewhere.
    substituteInPlace build_setup.py \
      --replace-fail \
        'X86_64 = platform.machine() in ("x86_64", "AMD64", "amd64")' \
        'X86_64 = ${if stdenv.hostPlatform.isx86_64 then "True" else "False"}'
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    mypy-extensions
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} smoke_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "librt"
    "librt.internal"
  ];

  meta = {
    description = "Mypyc runtime library";
    homepage = "https://github.com/mypyc/librt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
