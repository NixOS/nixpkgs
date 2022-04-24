{ lib, buildPythonPackage, fetchPypi, python, numpy, matplotlib, nose }:

buildPythonPackage rec {
  pname = "deap";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bvshly83c4h5jhxaa97z192viczymz5fxp6vl8awjmmrs9l9x8i";
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

