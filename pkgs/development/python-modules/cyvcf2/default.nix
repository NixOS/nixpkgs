{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python,

  # build-system
  cmake,
  cython,
  ninja,
  numpy,
  scikit-build-core,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  htslib,

  # dependencies
  click,
  coloredlogs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyvcf2";
  version = "0.34.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "cyvcf2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XDo2cEcZm5y6u9Gc2e7q2tg8pt3C/5cmnWRe6Dr5x7M=";
  };

  build-system = [
    cmake
    cython
    ninja
    numpy
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    htslib
  ];

  env = {
    # Link against the system htslib instead of building the bundled submodule
    CYVCF2_HTSLIB_MODE = "EXTERNAL";
  };

  dependencies = [
    click
    coloredlogs
    numpy
  ];

  pythonImportsCheck = [ "cyvcf2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Phase was read from the second allele slot, which for haploid records is
  # the next sample's; wrong since htslib >= 1.22 marks haploid genotypes as
  # phased. Debian patch by Andreas Tille, brentp/cyvcf2#336.
  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/med-team/cyvcf2/-/raw/46302a4a3189b579d849899960cb880bcba0c689/debian/patches/fix-haploid-genotype-phasing.patch";
      hash = "sha256-cvSDxjX36s1dCQ56ljDfw28PWqtdYYhUqJtXo5AC78c=";
    })
  ];

  # The test suite lives inside the package directory and relies on relative imports
  # (`from ..cyvcf2 import VCF`) as well as data files next to it, so it must run from the source
  # tree. Bring the compiled extension along.
  preCheck = ''
    cp $out/${python.sitePackages}/cyvcf2/cyvcf2*.so cyvcf2/
  '';

  meta = {
    description = "Cython wrapper around htslib built for fast parsing of Variant Call Format (VCF) files";
    homepage = "https://github.com/brentp/cyvcf2";
    changelog = "https://github.com/brentp/cyvcf2/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
