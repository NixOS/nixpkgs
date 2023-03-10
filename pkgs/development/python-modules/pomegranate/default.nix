{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, numpy
, scipy
, cython
, networkx
, joblib
, pandas
, nose
, pyyaml
}:


buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.14.8";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    # no tags for recent versions: https://github.com/jmschrei/pomegranate/issues/974
    rev = "0652e955c400bc56df5661db3298a06854c7cce8";
    sha256 = "16g49nl2bgnh6nh7bd21s393zbksdvgp9l13ww2diwhplj6hlly3";
  };

  propagatedBuildInputs = [ numpy scipy cython networkx joblib pyyaml ];

  nativeCheckInputs = [ pandas nose ];  # as of 0.13.5, it depends explicitly on nose, rather than pytest.

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
