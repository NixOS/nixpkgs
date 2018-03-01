{ lib, buildPythonPackage, fetchFromGitHub, python
, isPy3k, attrs, coverage, enum34
, doCheck ? true, pytest, pytest_xdist, flake8, flaky, mock
}:
buildPythonPackage rec {
  # http://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  version = "3.45.2";
  pname = "hypothesis";

  # Upstream prefers github tarballs
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = version;
    sha256 = "063sn5m1966gvm3wrlxczdq4vw0r94h3nd9xpr94qxahpg2r4bpb";
  };

  checkInputs = [ pytest pytest_xdist flaky mock ];
  propagatedBuildInputs = [ attrs coverage ] ++ lib.optional (!isPy3k) [ enum34 ];

  inherit doCheck;

  # https://github.com/DRMacIver/hypothesis/issues/300
  checkPhase = ''
    rm tox.ini # This file changes how py.test runs and breaks it
    py.test tests/cover
  '';

  meta = with lib; {
    description = "A Python library for property based testing";
    homepage = https://github.com/HypothesisWorks/hypothesis;
    license = licenses.mpl20;
  };
}
