{
  bwa,
  lib,
  fermi2,
  ropebwt2,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  name = "tiddit";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SciLifeLab";
    repo = "TIDDIT";
    tag = "TIDDIT-${version}";
    hash = "sha256-OeqVQJDw0fmSDWIGab2qtTJCzZxqLY2XzRqaTRuPIdI=";
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
}
