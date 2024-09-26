{
  lib,
  stdenv,
  bwa,
  fermi2,
  ropebwt2,
  zlib,
  python3,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  name = "tiddit";
  version = "3.6.1";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "SciLifeLab";
    repo = "TIDDIT";
    rev = "TIDDIT-3.6.1";
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
  propagatedBuildInputs = [
    fermi2
    ropebwt2
  ];

  meta = with lib; {
    homepage = "https://github.com/SciLifeLab/TIDDIT";
    description = "Identify chromosomal rearrangements using Mate Pair or Paired End sequencing data";
    mainProgram = "tiddit";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ apraga ];
    platforms = platforms.unix;
  };
}
