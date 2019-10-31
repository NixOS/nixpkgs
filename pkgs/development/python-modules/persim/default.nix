{ lib
, buildPythonPackage
, fetchPypi
, scikitlearn
, numpy
, matplotlib
, scipy
, hopcroftkarp
, pytest
}:

buildPythonPackage rec {
  pname = "persim";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "932bb0489d4dc158e4f007ec609c61e4700003d882d8e7bdac218b70d14ce9cf";
  };

  propagatedBuildInputs = [
    scikitlearn
    numpy
    matplotlib
    scipy
    hopcroftkarp
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc

    # ignore tests due to python 2.7 fail
    pytest --ignore test/test_plots.py \
           --ignore test/test_visuals.py
  '';

  meta = with lib; {
    description = "Distances and representations of persistence diagrams";
    homepage = https://persim.scikit-tda.org;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
