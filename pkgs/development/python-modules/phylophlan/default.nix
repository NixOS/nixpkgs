{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  biopython,
  dendropy,
  matplotlib,
  nix-update-script,
  numpy,
  pandas,
  requests,
  seaborn,
  setuptools,
}:

buildPythonPackage rec {
  pname = "phylophlan";
  version = "3.1.1";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "phylophlan";
    tag = version;
    hash = "sha256-KlWKt2tH2lQBh/eQ2Hbcu2gXHEFfmFEc6LrybluxINc=";
  };

  dependencies = [
    biopython
    dendropy
    matplotlib
    numpy
    pandas
    requests
    seaborn
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/biobakery/phylophlan/releases";
    description = "Precise phylogenetic analysis of microbial isolates and genomes from metagenomes";
    downloadPage = "https://pypi.org/project/PhyloPhlAn/#files";
    homepage = "https://github.com/biobakery/phylophlan";
    license = lib.licenses.mit;
    mainProgram = "phylophlan";
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
