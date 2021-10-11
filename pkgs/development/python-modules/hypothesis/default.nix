{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, attrs
, pexpect
, doCheck ? true
, pytestCheckHook
, pytest-xdist
, sortedcontainers
, tzdata
}:
buildPythonPackage rec {
  # https://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  pname = "hypothesis";
  version = "6.23.2";

  # Use github tarballs that includes tests
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = "hypothesis-python-${version}";
    sha256 = "1mdygyq6ra4kysi0y2g3a4bgpqrcb8ci2061117zyms419qwwh4l";
  };

  postUnpack = "sourceRoot=$sourceRoot/hypothesis-python";

  propagatedBuildInputs = [
    attrs
    sortedcontainers
  ];

  checkInputs = [ pytestCheckHook pytest-xdist pexpect ]
    ++ lib.optional (pythonAtLeast "3.9") tzdata;

  inherit doCheck;

  # This file changes how pytest runs and breaks it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlagsArray = [ "tests/cover" ];

  meta = with lib; {
    description = "A Python library for property based testing";
    homepage = "https://github.com/HypothesisWorks/hypothesis";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
