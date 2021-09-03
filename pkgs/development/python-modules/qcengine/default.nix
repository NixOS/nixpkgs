{ buildPythonPackage, lib, fetchPypi, pyyaml, qcelemental, pydantic
, py-cpuinfo, psutil, pytest-runner, pytest, pytest-cov
} :

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.19.0";

  checkInputs = [
    pytest-runner
    pytest-cov
    pytest
  ];

  propagatedBuildInputs = [
    pyyaml
    qcelemental
    pydantic
    py-cpuinfo
    psutil
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lz9r0fh31mcixdhayiwfc69cp8if9b3nkrk7gxdrb6vhbfrxhij";
  };

  doCheck = true;

  meta = with lib; {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
