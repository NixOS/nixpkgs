{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-codon-tables";
  version = "0.1.15";
  format = "setuptools";

  src = fetchPypi {
    pname = "python_codon_tables";
    inherit version;
    hash = "sha256-bK0Y8y5W6xmtGeRUtLDGsg1voVKp1uU37tBqi0/raLY=";
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
