{ lib
, buildPythonPackage
, fetchPypi
, deprecated
, hopcroftkarp
, joblib
, matplotlib
, numpy
, scikitlearn
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "persim";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5db2f7f65b1ad7b2cbfa254afb692ca0a91aeb686e82d6905838c41f516e6a13";
  };

  propagatedBuildInputs = [
    deprecated
    hopcroftkarp
    joblib
    matplotlib
    numpy
    scikitlearn
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  meta = with lib; {
    description = "Distances and representations of persistence diagrams";
    homepage = "https://persim.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
