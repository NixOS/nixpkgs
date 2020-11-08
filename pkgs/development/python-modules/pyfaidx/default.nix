{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.5.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eda8af04ba4da4fd63fdc35a62e0e41dfc06aa1a511728dfbdd7707e3b382855";
  };

  requiredPythonModules = [ six ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = [ maintainers.jbedo ];
  };
}
