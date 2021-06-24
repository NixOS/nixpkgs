{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.5.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73e740eaa45c097a09e543450f88d5ed06c0ece4b6936dad7e71077f67797b74";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = [ maintainers.jbedo ];
  };
}
