{
  lib,
  buildPythonPackage,
  appdirs,
  biopython,
  fetchPypi,
  proglog,
  setuptools,
}:

buildPythonPackage rec {
  pname = "genome-collector";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    pname = "genome_collector";
    inherit version;
    sha256 = "0023ihrz0waxbhq28xh1ymvk51ih882y9psg4glm6s9d1zmqvdph";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "import ez_setup" "" \
      --replace-fail "ez_setup.use_setuptools()" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    biopython
    proglog
  ];

  # Project hasn't released the tests yet
  doCheck = false;
  pythonImportsCheck = [ "genome_collector" ];

  meta = {
    description = "Genomes and build BLAST/Bowtie indexes in Python";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/genome_collector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
