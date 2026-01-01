{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-codon-tables";
  version = "0.1.18";
  pyproject = true;

  src = fetchPypi {
    pname = "python_codon_tables";
    inherit version;
    hash = "sha256-c/VSmArSkq+46LzW3r+CQEG1mwp87ACbZ7EWkMOGOQc=";
  };

  build-system = [ setuptools ];

  # no tests in tarball
  doCheck = false;

  pythonImportsCheck = [ "python_codon_tables" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/codon-usage-tables";
    description = "Codon Usage Tables for Python, from kazusa.or.jp";
    changelog = "https://github.com/Edinburgh-Genome-Foundry/python_codon_tables/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
=======
  meta = with lib; {
    homepage = "https://github.com/Edinburgh-Genome-Foundry/codon-usage-tables";
    description = "Codon Usage Tables for Python, from kazusa.or.jp";
    changelog = "https://github.com/Edinburgh-Genome-Foundry/python_codon_tables/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
