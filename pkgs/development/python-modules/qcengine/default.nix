{ buildPythonPackage, lib, fetchPypi, pyyaml, qcelemental, pydantic
, py-cpuinfo, psutil, pytest-runner, pytest, pytest-cov
} :

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.20.0";

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
    sha256 = "5b405efb4b6ebe81e7f991b360126a4f61c2768ceed6027346e2b8ef3f57ef39";
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
