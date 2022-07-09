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
  version = "0.24.0";

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
    sha256 = "sha256-T6/gC3HHCnI3O1Gkj/MdistL93bwymtEfNF6PmA7TN0=";
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
