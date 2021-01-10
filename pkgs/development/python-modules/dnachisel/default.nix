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
  version = "3.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i49cfpvjvf9610gg4jz06dl5clc8vmcpjmhnm2d1j7lhpp1ksbb";
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
