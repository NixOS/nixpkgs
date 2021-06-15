{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.5.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9965644c5bd62bedc0ff7f336cbb2baef6406a36b4ec5c786b199872ce46192b";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = [ maintainers.jbedo ];
  };
}
