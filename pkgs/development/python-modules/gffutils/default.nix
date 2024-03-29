{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
  pkgs,
}:

with python3.pkgs;

  buildPythonApplication rec {
    pname = "gffutils";
    version = "0.12.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "daler";
      repo = "gffutils";
      rev = "v${version}";
      hash = "sha256-IU4KIkejU2p0DBpznk6kQR5lYqWYNjle40e4XKu+H0g=";
    };

    testsrc1 = fetchurl {
      url = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M28/gencode.vM28.annotation.gtf.gz";
      sha256 = "sha256-rDoey8nG5OszLMN/qYM40V4TGFQmzrnJjRHl9ODkNB8=";
    };

    testsrc2 = fetchurl {
      url = "ftp://ftp.ensembl.org/pub/release-83/gff3/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.83.gff3.gz";
      sha256 = "sha256-skEtp4G7aFwXrHXWOfb1Gl2fhVgpTwJE7B8ETlRlfPg=";
    };

    nativeBuildInputs = [
      setuptools
      wheel
    ];

    propagatedBuildInputs = [
      argcomplete
      argh
      pyfaidx
      simplejson
      six
    ];

    nativeCheckInputs = [
      pytest
      pkgs.gzip
    ];

    checkPhase = ''
      cp ${testsrc1} gffutils/test/data/gencode.vM28.annotation.gtf.gz
      cp ${testsrc2} gffutils/test/data/Saccharomyces_cerevisiae.R64-1-1.83.gff3.gz
      gzip -d gffutils/test/data/Saccharomyces_cerevisiae.R64-1-1.83.gff3.gz
    '';

    pythonImportsCheck = ["gffutils"];

    meta = with lib; {
      description = "GFF and GTF file manipulation and interconversion";
      homepage = "https://github.com/daler/gffutils";
      license = licenses.mit;
      maintainers = with maintainers; [lilacious];
      mainProgram = "gffutils";
    };
  }
