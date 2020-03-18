{ stdenv, buildPythonPackage, fetchPypi, numpy, scipy, future, six, matplotlib
}:

buildPythonPackage rec {
  pname = "mir_eval";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b656eed19311fb8d73a7fa85e9dbc613cca255ff2342fbd3ebcedfec4ef73c5e";
  };

  propagatedBuildInputs = [ numpy scipy future six ];
  checkInputs = [ matplotlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/craffel/mir_eval";
    description = ''
      Evaluation functions for music/audio information retrieval/signal processing algorithms.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ jmorag ];
  };

}
