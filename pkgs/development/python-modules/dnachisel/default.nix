{ lib
, buildPythonPackage
, fetchPypi
, biopython
, docopt
, flametree
, numpy
, proglog
, python-codon-tables
 }:

buildPythonPackage rec {
  pname = "dnachisel";
  version = "3.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35301c5eda0baca5902403504e0b5a22eb65da92c2bbd23199d95c4a6bf0ef37";
  };

  propagatedBuildInputs = [
    biopython
    docopt
    flametree
    numpy
    proglog
    python-codon-tables
  ];

  # no tests in tarball
  doCheck = false;

  pythonImportsCheck = [ "dnachisel" ];

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/DnaChisel";
    description = "Optimize DNA sequences under constraints";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
