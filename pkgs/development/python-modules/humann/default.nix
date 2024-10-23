{
  lib,
  python,
  buildPythonPackage,
  callPackage,
  fetchzip,
  fetchFromGitHub,
  setuptools,
  biom-format,
  bowtie2,
  diamond,
  samtools,
  humann-db,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "humann";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "humann";
    rev = "refs/tags/${version}";
    hash = "sha256-EieeZ9nnVCTgm7WZ+mYT99KnB3PtgjiK7HfCjHwNw8g=";
  };

  build-system = [ setuptools ];

  dependencies = [ biom-format ];

  postInstall =
    ''
      for program in $out/bin/*; do
        wrapProgram $out/bin/$(basename $program) \
          --prefix PATH : ${
            lib.makeBinPath [
              bowtie2
              diamond
              samtools
            ]
          }
      done
    ''
    + lib.optionalString (humann-db != null) ''
      rm -rf $out/${python.sitePackages}/humann/data
      substituteInPlace $out/${python.sitePackages}/humann/humann.cfg \
        --replace-fail "data/chocophlan_DEMO" "${humann-db}/nucleotide_database" \
        --replace-fail "data/uniref_DEMO" "${humann-db}/protein_database" \
        --replace-fail "data/misc" "${humann-db}/utility_mapping"
    '';

  passthru = {
    updateScript = nix-update-script { };
    tests = callPackage ./tests.nix { };
  };

  meta = {
    description = "Pipeline for metagenomic functional profiling";
    homepage = "https://github.com/biobakery/humann";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "humann";
  };
}
