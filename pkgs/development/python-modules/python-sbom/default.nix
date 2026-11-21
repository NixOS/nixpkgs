{
  lib,
  addBinToPathHook,
  build,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  flit-core,
  gitMinimal,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  installer,
  jsonschema-rs,
  license-expression,
  meson-python,
  packageurl-python,
  packaging,
  pdm-backend,
  poetry-core,
  pytest-mock,
  pytestCheckHook,
  scikit-build-core,
  setuptools,
  spdx-tools,
  uv-build,
  versionCheckHook,
  zipremove,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-sbom";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "python-sbom";
    tag = finalAttrs.version;
    hash = "sha256-3PISPLGVcaJmCuUh/kxZTqS3kmYqWmYFqS+96LhxhJA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling>=1.32.4' 'hatchling' \
      --replace-fail 'installer>=1.1' 'installer'
    substituteInPlace tests/_cli/test_main.py \
      --replace-fail 'Path(sys.executable).parent / "python-sbom"' "Path('$out/bin/python-sbom')"
    substituteInPlace tests/examples/conftest.py \
      --replace-fail 'shutil.which(name, path=sysconfig.get_path("scripts"))' 'shutil.which(name)'
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
    installer
    packageurl-python
    zipremove
  ];

  dependencies = [
    installer
    packageurl-python
    packaging
    zipremove
  ];

  optional-dependencies = {
    hatch = [ hatchling ];
    pdm = [ pdm-backend ];
    setuptools = [ setuptools ];
    validate = [
      jsonschema-rs
      license-expression
      spdx-tools
    ];
  };

  nativeCheckInputs = [
    # Declared
    flit-core
    hatchling
    installer
    jsonschema-rs
    pdm-backend
    pytest-mock
    pytestCheckHook
    setuptools
    spdx-tools
    # Undeclared/extra/system
    addBinToPathHook
    build
    cmake
    gitMinimal
    meson-python
    poetry-core
    scikit-build-core
    uv-build
    versionCheckHook
  ];

  disabledTestPaths = [
    # Require unpackaged build system dependencies
    "tests/examples/cibuildwheel"
    "tests/examples/delocate"
    # Not packaged as a Python module yet
    "tests/examples/maturin"
    # Depends on the current time or file timestamps
    "tests/_collect/test_facts.py::test_epoch_default"
    "tests/_collect/test_facts.py::test_epoch_without_default_is_now"
    "tests/hatch/test_hook.py::test_reproducible_build_uses_hatchling_time"
    "tests/hatch/test_hook.py::test_non_reproducible_build_uses_current_time"
    "tests/test_pdm.py::test_reproducible_build_uses_pdm_backend_time"
  ];

  pythonImportsCheck = [ "python_sbom" ];

  meta = {
    changelog = "https://github.com/tox-dev/python-sbom/releases/tag/${finalAttrs.src.tag}";
    description = "SBOMs for Python distributions: write PEP 770 CycloneDX SBOMs into wheels";
    homepage = "https://github.com/tox-dev/python-sbom";
    license =
      with lib.licenses;
      AND [
        asl20
        mit
      ];
    maintainers = [ lib.maintainers.mdaniels5757 ];
    mainProgram = "python-sbom";
  };
})
