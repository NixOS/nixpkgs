{ lib, buildPythonPackage, fetchPypi, numpy, scipy, six, decorator, nose }:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0917211c0f083f344e7f1bc997e0d713dbc147b6380bc19f606119394f820b9a";
  };

  propagatedBuildInputs = [ numpy scipy six decorator ];
  nativeCheckInputs = [ nose ];

  # Ran 113 tests in 3.082s
  checkPhase = ''
      nosetests -v paramz/tests
  '';

  meta = with lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = "https://github.com/sods/paramz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
