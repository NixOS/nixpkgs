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
  pysam,
  reportlab,
  rPackages,
  scikit-learn,
  scipy,
  R,
  # tests
  pytestCheckHook,

}:
buildPythonPackage rec {
  pname = "cnvkit";
  version = "0.9.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "etal";
    repo = "cnvkit";
    tag = "v${version}";
    hash = "sha256-ZdE3EUNZpEXRHTRKwVhuj3BWQWczpdFbg4pVr0+AHiQ=";
  };

  patches = [
    (fetchpatch {
      name = "fix-numpy2-compat";
      url = "https://github.com/etal/cnvkit/commit/5cb6aeaf40ea5572063cf9914c456c307b7ddf7a.patch";
      hash = "sha256-VwGAMGKuX2Kx9xL9GX/PB94/7LkT0dSLbWIfVO8F9NI=";
    })
  ];

  pythonRelaxDeps = [
    # https://github.com/etal/cnvkit/issues/815
    "pomegranate"
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
    # Numpy 2 compatibility
    ''
      substituteInPlace skgenome/intersect.py \
        --replace-fail "np.string_" "np.bytes_"
    ''
    # Patch shebang lines in R scripts
    + ''
      substituteInPlace cnvlib/segmentation/flasso.py \
        --replace-fail "#!/usr/bin/env Rscript" "#!${rscript}"

      substituteInPlace cnvlib/segmentation/cbs.py \
        --replace-fail "#!/usr/bin/env Rscript" "#!${rscript}"

      substituteInPlace cnvlib/segmentation/__init__.py \
        --replace-fail 'rscript_path="Rscript"' 'rscript_path="${rscript}"'

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
    changelog = "https://github.com/etal/cnvkit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jbedo ];
  };
}
