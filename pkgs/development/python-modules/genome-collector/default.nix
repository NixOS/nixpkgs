{
  lib,
  buildPythonPackage,
  appdirs,
  biopython,
  fetchPypi,
  proglog,
}:

buildPythonPackage rec {
  pname = "genome_collector";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0023ihrz0waxbhq28xh1ymvk51ih882y9psg4glm6s9d1zmqvdph";
  };

  propagatedBuildInputs = [
    appdirs
    biopython
    proglog
  ];

  # Project hasn't released the tests yet
  doCheck = false;
  pythonImportsCheck = [ "genome_collector" ];

  meta = with lib; {
    description = "Genomes and build BLAST/Bowtie indexes in Python";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/genome_collector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
