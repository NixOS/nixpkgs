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
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a644a932c5aaf6976bd59003d2823db9276779aa4f9d99dcccc99dc234c80c1f";
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
