{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
}:

buildPythonPackage rec {
  pname = "ipynbname";
  version = "2023.2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Riu915VmJIdtxOqB+nkoRas4cOREyh9res2uo32Mnr8=";
  };

  propagatedBuildInputs = [
    ipykernel
  ];

  pythonImportsCheck = [ "ipynbname" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Simply returns either notebook filename or the full path to the notebook";
    homepage = "https://github.com/msm1089/ipynbname";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
