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
    sha256 = "hZxE7b0bOx/B8Kz4cgBC7wV23OikRxwrdZ4UQ8G/yhg=";
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
