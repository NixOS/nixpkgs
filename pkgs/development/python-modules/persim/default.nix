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
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52ce59856de25eec74c6f20951301b13e7d98c434e712d2225653e2087d54fbc";
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
