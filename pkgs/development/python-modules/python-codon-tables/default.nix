{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-codon-tables";
  version = "0.1.11";

  src = fetchPypi {
    pname = "python_codon_tables";
    inherit version;
    sha256 = "ba590fcfb1988f9674c8627464caeb3ea0797d970872a2c27ea09906acd24110";
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
