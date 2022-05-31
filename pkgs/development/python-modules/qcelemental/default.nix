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
  version = "0.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XcsR89tu26EG5AcXqmndkESLGWZ8eKmTkjaLziosawE=";
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
