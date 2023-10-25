{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    # no tags for recent versions: https://github.com/jmschrei/pomegranate/issues/974
    rev = "refs/tags/v${version}";
    sha256 = "sha256-EnxKlRRfsOIDLAhYOq7bUSbI/NvPoSyYCZ9D5VCXFGQ=";
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
