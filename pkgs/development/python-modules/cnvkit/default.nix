{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python,
  makeWrapper,
  # dependencies
  biopython,
  matplotlib,
  numpy,
  pandas,
  pomegranate,
  pyfaidx,
  pyparsing,
  pysam,
  reportlab,
  rPackages,
  scikit-learn,
  scipy,
  R,
  # tests
  pytestCheckHook,

}:
buildPythonPackage (finalAttrs: {
  pname = "cnvkit";
  version = "0.9.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6W0rJUeHO7m3zacgkL3WzyFVmdet1zJAGyafsQv1AXE=";
  };

  patches = [
    # test: update a call to --smooth-bootstrap[=int, now]
    (fetchpatch {
      url = "https://github.com/etal/cnvkit/commit/c5c7c06b7fb873ed7ae44593c11a91d45f433e54.patch";
      hash = "sha256-H9Nr4JL7bc9CQ/BmXkOAwjbr/ykvbnjyyWrVSrVH9kg=";
    })
  ];

  pythonRelaxDeps = [
    # https://github.com/etal/cnvkit/issues/815
    "pomegranate"
    # https://github.com/etal/cnvkit/pull/1048
    "pyparsing"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    R
  ];

  postPatch =
    let
      rscript = lib.getExe' R "Rscript";
    in
    # Patch shebang lines in R scripts
    ''
      substituteInPlace cnvlib/segmentation/flasso.py \
        --replace-fail "#!/usr/bin/env Rscript" "#!${rscript}"

      substituteInPlace cnvlib/segmentation/cbs.py \
        --replace-fail "#!/usr/bin/env Rscript" "#!${rscript}"

      substituteInPlace cnvlib/segmentation/__init__.py \
        --replace-fail 'rscript_path: str = "Rscript"' 'rscript_path="${rscript}"'

      substituteInPlace cnvlib/commands.py \
        --replace-fail 'default="Rscript"' 'default="${rscript}"'

    '';

  dependencies = [
    biopython
    matplotlib
    numpy
    pandas
    pomegranate
    pyfaidx
    pyparsing
    pysam
    reportlab
    rPackages.DNAcopy
    scikit-learn
    scipy
  ];

  # Make sure R can find the DNAcopy package
  postInstall = ''
    wrapProgram $out/bin/cnvkit.py \
      --set R_LIBS_SITE "${rPackages.DNAcopy}/library" \
       --set MPLCONFIGDIR "/tmp/matplotlib-config"
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    ${python.executable} -m pytest --deselect=test/test_commands.py::CommandTests::test_batch \
      --deselect=test/test_commands.py::CommandTests::test_segment_hmm

      cd test
      # Set matplotlib config directory for the tests
      export MPLCONFIGDIR="/tmp/matplotlib-config"
      export HOME="/tmp"
      mkdir -p "$MPLCONFIGDIR"

      # Use the installed binary - it's already wrapped with R_LIBS_SITE
      make cnvkit="$out/bin/cnvkit.py" || {
        echo "Make tests failed"
        exit 1
      }

    runHook postInstallCheck
  '';

  doInstallCheck = true;

  pythonImportsCheck = [ "cnvlib" ];

  nativeCheckInputs = [
    pytestCheckHook
    R
  ];

  meta = {
    homepage = "https://cnvkit.readthedocs.io";
    description = "Python library and command-line software toolkit to infer and visualize copy number from high-throughput DNA sequencing data";
    changelog = "https://github.com/etal/cnvkit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jbedo ];
  };
})
