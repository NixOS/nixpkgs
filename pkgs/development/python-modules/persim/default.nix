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
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be4ea4bfc2a0c6fcfc28ebd52e23a351ee00b0ef0ddaf527526bd0f919145348";
  };

  requiredPythonModules = [
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
    homepage = "https://persim.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
