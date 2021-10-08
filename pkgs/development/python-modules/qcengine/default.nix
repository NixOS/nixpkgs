{ buildPythonPackage, lib, fetchPypi, pyyaml, qcelemental, pydantic
, py-cpuinfo, psutil, pytest-runner, pytest, pytest-cov
} :

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.20.1";

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
    sha256 = "859c44edbd1b3b1fc1f0acf8720042ef0576dce8a4471c2b759e1443c1bfca18";
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
