{ lib, buildPythonPackage, fetchFromGitHub
, isPy3k, attrs, coverage, enum34
, doCheck ? true, pytest, pytest_xdist, flaky, mock
}:
buildPythonPackage rec {
  # https://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  version = "4.7.3";
  pname = "hypothesis";

  # Use github tarballs that includes tests
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = "hypothesis-python-${version}";
    sha256 = "03l4hp0p7i2k04arnqkav0ygc23ml46dy3cfrlwviasrj7yzk5hc";
  };

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  propagatedBuildInputs = [ attrs coverage ] ++ lib.optional (!isPy3k) [ enum34 ];

  checkInputs = [ pytest pytest_xdist flaky mock ];
  inherit doCheck;

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
