{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, numpy
, joblib
, networkx
, scipy
, pyyaml
, cython
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.14.8";
  pyproject = true;

  src = fetchFromGitHub {
    repo = pname;
    owner = "jmschrei";
    # no tags for recent versions: https://github.com/jmschrei/pomegranate/issues/974
    rev = "refs/tags/v${version}";
    hash = "sha256-PoDAtNm/snq4isotkoCTVYUuwr9AKKwiXIojUFMH/YE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    joblib
    networkx
    scipy
    pyyaml
    cython
  ];

  # https://github.com/etal/cnvkit/issues/815
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
