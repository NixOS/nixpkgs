{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mypy-extensions,
  python,
  pytest,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "librt";
  version = "0.11.0";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "librt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y9z1EdrZRiDtT8cxz/Ex/f6B/RfjnAXdGf7tM+77HGg=";
  };

  # https://github.com/mypyc/librt/blob/v0.7.8/.github/workflows/buildwheels.yml#L90-L93
  postPatch = ''
    cp -rv lib-rt/* .
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mypyc runtime library";
    homepage = "https://github.com/mypyc/librt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jackr ];
  };
})
