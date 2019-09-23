{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, cython, networkx, joblib, nose, pyyaml }:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.11.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    sha256 = "0gf7z343ag4g7pfccn1sdap3ihkaxrc9ca75awjhmsa2cyqs66df";
  };

  propagatedBuildInputs = [ numpy scipy cython networkx joblib pyyaml ];

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = https://github.com/jmschrei/pomegranate;
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
