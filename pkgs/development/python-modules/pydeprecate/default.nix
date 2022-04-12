{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydeprecate";
  version = "0.3.1";
  src = fetchPypi {
    inherit version;
    pname = "pyDeprecate";
    sha256 = "+iaHCSTTR1Yhw0QEXCwBoWugNBE6kCYAx451s/rF9yw=";
  };
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Simple tooling for marking deprecated functions or classes and re-routing to the new successors’ instance.";
    homepage = "https://borda.github.io/pyDeprecate/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cfhammill ];
  };

}
