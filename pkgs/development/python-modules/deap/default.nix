{ lib, buildPythonPackage, fetchPypi, numpy, matplotlib, nose }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h3LxsP/wQtXlFrCuusLHBiQwRap9DejguGWPOAGBzzE=";
  };

  propagatedBuildInputs = [ numpy matplotlib ];

  nativeCheckInputs = [ nose ];
  checkPhase = ''
    nosetests --verbosity=3
  '';

  meta = with lib; {
    description = "DEAP is a novel evolutionary computation framework for rapid prototyping and testing of ideas.";
    homepage = "https://github.com/DEAP/deap";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };

}

