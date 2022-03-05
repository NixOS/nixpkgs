{ buildPythonPackage
, lib
, fetchPypi
, psutil
, py-cpuinfo
, pydantic
, pyyaml
, qcelemental
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.22.0";

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "685a08247b561ed1c7a7b42e68293f90b412e83556626304a3f826a15be51308";
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
