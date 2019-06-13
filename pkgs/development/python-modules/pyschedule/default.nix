{ lib
, buildPythonPackage
, fetchPypi
, pulp
}:

buildPythonPackage rec {
  pname = "pyschedule";
  version = "0.2.34";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bba9e9ea07906ce2dfe3cd847c1822b137f6b13e9f975c50b347312fd98e110";
  };

  propagatedBuildInputs = [
    pulp
  ];

  # tests not included with pypi release (in examples)
  doCheck = false;

  meta = with lib; {
    description = "Formulate and solve resource-constrained scheduling problems";
    homepage = https://github.com/timnon/pyschedule;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
