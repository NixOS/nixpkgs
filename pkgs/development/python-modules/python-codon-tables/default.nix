{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-codon-tables";
  version = "0.1.12";

  src = fetchPypi {
    pname = "python_codon_tables";
    inherit version;
    sha256 = "sha256-pzPoR55nU8ObPv1iIE52qpqD5xGdYLm1uG3nCD6I46Y=";
  };

  # no tests in tarball
  doCheck = false;

  pythonImportsCheck = [ "python_codon_tables" ];

  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/codon-usage-tables";
    description = "Codon Usage Tables for Python, from kazusa.or.jp";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
