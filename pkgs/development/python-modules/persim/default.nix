{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, deprecated
, hopcroftkarp
, joblib
, matplotlib
, numpy
, scikit-learn
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "persim";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef0f0a247adcf6104ecac14117db0b24581710ea8a8d964816805395700b4975";
  };

  propagatedBuildInputs = [
    deprecated
    hopcroftkarp
    joblib
    matplotlib
    numpy
    scikit-learn
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
    broken = stdenv.isDarwin;
    description = "Distances and representations of persistence diagrams";
    homepage = "https://persim.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
