{
  bwa,
  lib,
  fermi2,
  ropebwt2,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tiddit";
  version = "3.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SciLifeLab";
    repo = "TIDDIT";
    tag = "TIDDIT-${finalAttrs.version}";
    hash = "sha256-B3vUxLEnOdX733iGOfMmueVaSEqMmlp6fN4M8oElNNQ=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    cython
    joblib
    numpy
    pysam
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        bwa
        fermi2
        ropebwt2
      ]
    }"
    "--set PYTHONPATH $PYTHONPATH"
  ];

  meta = {
    homepage = "https://github.com/SciLifeLab/TIDDIT";
    description = "Identify chromosomal rearrangements using Mate Pair or Paired End sequencing data";
    mainProgram = "tiddit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ apraga ];
    platforms = lib.platforms.unix;
  };
})
