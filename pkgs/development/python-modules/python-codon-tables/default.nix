{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-codon-tables";
  version = "0.1.10";

  src = fetchPypi {
    pname = "python_codon_tables";
    inherit version;
    sha256 = "265beac928cbb77c6745bc728471adc7ffef933b794be303d272ecb9ad37d3d4";
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
