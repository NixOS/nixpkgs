{ stdenv
, buildPythonPackage, lib, fetchPypi
, networkx
, numpy
, pint
, pydantic
, pytestCheckHook
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v1yu6yBEtgVsheku/8YaIaXrsVgMzcFlWAuySPhYgyQ=";
  };

  propagatedBuildInputs = [
    numpy
    pydantic
    pint
    networkx
  ];

  checkInputs = [ pytestCheckHook ];

  doCheck = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Periodic table, physical constants, and molecule parsing for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    maintainers = [ maintainers.sheepforce ];
  };
}
