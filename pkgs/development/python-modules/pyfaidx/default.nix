{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1258f8d053cba0c90fe329254e8ec59eb28b535b48d9d06e8c7f1d74b8e4531";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = [ maintainers.jbedo ];
  };
}
