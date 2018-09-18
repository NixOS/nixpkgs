{ lib, buildPythonPackage, fetchFromGitHub
, isPy3k, attrs, coverage, enum34
, doCheck ? true, pytest, pytest_xdist, flaky, mock
}:

buildPythonPackage (rec {
  # http://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  version = "3.69.2";
  pname = "hypothesis";

  # Use github tarballs that includes tests
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = "hypothesis-python-${version}";
    sha256 = "08pg05s7866sd32d48n9m4rkl5h758dv2qjjkz1yjhn6djqpisnl";
  };

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  propagatedBuildInputs = [ attrs coverage ] ++ lib.optional (!isPy3k) [ enum34 ];

  checkInputs = [ pytest pytest_xdist flaky mock ];
  inherit doCheck;

  meta = with lib; {
    description = "A Python library for property based testing";
    homepage = https://github.com/HypothesisWorks/hypothesis;
    license = licenses.mpl20;
  };
}
//
# We use this trick to avoid rebuilding py.test, if only checkPhase was changed.
(if doCheck then {
  checkPhase = ''
    rm tox.ini # This file changes how py.test runs and breaks it
    py.test tests/cover
  '';
} else {}))
