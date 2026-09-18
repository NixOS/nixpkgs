{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cython,
  setuptools,

  # buildInputs
  zlib,

  # dependencies
  bedtools,
  numpy,
  pandas,
  pysam,

  # tests
  psutil,
  pytestCheckHook,
  pyyaml,
}:
buildPythonPackage (finalAttrs: {
  pname = "pybedtools";
  version = "0.12.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "daler";
    repo = "pybedtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s+MSiNtGwR7Gshka7NeBE+OnHiht1R6xh4Sx8/0wfS0=";
  };

  postPatch =
    # `pybedtools` shells out to the BEDTools executables. Hardcode their location
    # instead of relying on them being present in `PATH`.
    ''
      substituteInPlace pybedtools/settings.py \
        --replace-fail \
          '_bedtools_path = ""' \
          '_bedtools_path = "${lib.getBin bedtools}/bin"'
    '';

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    zlib
  ];

  dependencies = [
    numpy
    pandas
    pysam
  ];

  pythonImportsCheck = [ "pybedtools" ];

  nativeCheckInputs = [
    bedtools
    psutil
    pytestCheckHook
    pyyaml
  ];

  # The package ships compiled extension modules, so run the test suite against
  # the installed copy rather than the source tree.
  preCheck = ''
    cd $out/${python.sitePackages}
  '';

  enabledTestPaths = [ "pybedtools/test" ];

  disabledTests = [
    # Requires internet access
    "test_chromsizes"

    # FileNotFoundError: [Errno 2] No such file or directory: '/bin/bash'
    "test_issue_303"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert '' == 'chr1\t1\t100...ture4\t0\t+\n'
    "test_all"
  ];

  meta = {
    description = "Wrapper around BEDTools for bioinformatics work";
    homepage = "https://github.com/daler/pybedtools";
    changelog = "https://github.com/daler/pybedtools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
