{ lib, buildPythonPackage, fetchPypi, python, numpy, matplotlib, nose }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h3LxsP/wQtXlFrCuusLHBiQwRap9DejguGWPOAGBzzE=";
  };

  postPatch = ''
    sed -i '/use_2to3=True/d' setup.py
  '';

  propagatedBuildInputs = [ numpy matplotlib ];

  preBuild = ''
    2to3 -wn deap
  '';

  checkInputs = [ nose ];
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

