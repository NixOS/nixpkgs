{ lib, buildPythonPackage, fetchPypi, nose2, numpy, pyomo, scipy, bonmin, ipopt }:

buildPythonPackage rec {
  pname = "rbfopt";
  version = "4.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q0iGUWMQBSFtvNkSYk4JgvC+eIrLqFiPB9ZwYppmtNE=";
  };

  postPatch = ''
    # patch in the absolute paths
    # note that tests for rbfopt_settings.py ensure the default values match the actual
    # value, so we have to patch those as well
    substituteInPlace src/rbfopt/rbfopt_settings.py \
      --replace "minlp_solver_path='bonmin'," "minlp_solver_path='${bonmin}/bin/bonmin'," \
      --replace "nlp_solver_path='ipopt'," "nlp_solver_path='${ipopt}/bin/ipopt'," \
      --replace "Default 'bonmin'." "Default '${bonmin}/bin/bonmin'." \
      --replace "Default 'ipopt'." "Default '${ipopt}/bin/ipopt'."
  '';

  propagatedBuildInputs = [
    nose2
    numpy
    pyomo
    scipy
  ];

  checkInputs = [
    nose2
  ];

  # tests never finish
  # see https://github.com/coin-or/rbfopt/issues/44
  doCheck = false;

  pythonImportsCheck = [
    "rbfopt"
  ];

  meta = with lib; {
    homepage = "https://github.com/coin-or/rbfopt";
    description = "A Python library for black-box optimization (also known as derivative-free optimization)";
    maintainers = with maintainers; [ aanderse ];
    license = licenses.bsd3;
  };
}
