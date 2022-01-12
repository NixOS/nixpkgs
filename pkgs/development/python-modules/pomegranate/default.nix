{ lib
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
  version = "0.13.5";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    rev = "v${version}";
    sha256 = "1hbxchp3daykkf1fa79a9mh34p78bygqcf1nv4qwkql3gw0pd6l7";
  };

  patches = lib.optionals (lib.versionOlder version "13.6") [
    # Fix compatibility with recent joblib release, will be part of the next
    # pomegranate release after 0.13.5
    (fetchpatch {
      url = "https://github.com/jmschrei/pomegranate/commit/42d14bebc44ffd4a778b2a6430aa845591b7c3b7.patch";
      sha256 = "0f9cx0fj9xkr3hch7jyrn76zjypilh5bqw734caaw6g2m49lvbff";
    })
  ] ++ [
    # Likely an upstream test bug and not a real problem:
    #   https://github.com/jmschrei/pomegranate/issues/939
    ./disable-failed-on-nextworkx-2.6.patch
  ] ;

  propagatedBuildInputs = [ numpy scipy cython networkx joblib pyyaml ];

  checkInputs = [ pandas nose ];  # as of 0.13.5, it depends explicitly on nose, rather than pytest.

  meta = with lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
