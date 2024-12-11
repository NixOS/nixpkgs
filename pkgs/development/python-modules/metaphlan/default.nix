{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  biom-format,
  biopython,
  dendropy,
  h5py,
  hclust2,
  metaphlan-db,
  nix-update-script,
  numpy,
  pandas,
  phylophlan,
  pysam,
  python,
  requests,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "metaphlan";
  version = "4.1.0";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "MetaPhlAn";
    tag = version;
    hash = "sha256-+7K5gVLRUYSulMDLszlUsKbNLNg57le63wLPtl26D8c=";
  };

  dependencies = [
    numpy
    h5py
    biom-format
    biopython
    hclust2
    pandas
    phylophlan
    scipy
    requests
    dendropy
    pysam
  ];

  postInstall = lib.optionalString (metaphlan-db != null) ''
    rm -rf $out/${python.sitePackages}/metaphlan/metaphlan_databases
    ln -s ${metaphlan-db} $out/${python.sitePackages}/metaphlan/metaphlan_databases
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/biobakery/MetaPhlAn/releases";
    description = "MetaPhlAn is a computational tool for profiling the composition of microbial communities from metagenomic shotgun sequencing data";
    downloadPage = "https://pypi.org/project/MetaPhlAn/#files";
    homepage = "https://github.com/biobakery/MetaPhlAn";
    license = lib.licenses.mit;
    mainProgram = "metaphlan";
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
