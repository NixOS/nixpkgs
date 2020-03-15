{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "038xi3a6zvrxbyyfpp64ka8pcjgsdq4fgw9cl5lpxbvmm1bzzw2q";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = [ maintainers.jbedo ];
  };
}
