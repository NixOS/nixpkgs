{ stdenv, buildPythonPackage, fetchFromGitHub, python
, pythonOlder, pythonAtLeast, enum34
, doCheck ? true, pytest, pytest_xdist, flake8, flaky
}:
buildPythonPackage rec {
  # http://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  version = "3.11.1";
  pname = "hypothesis";
  name = "${pname}-${version}";

  # Upstream prefers github tarballs
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis-python";
    rev = "${version}";
    sha256 = "0damf6zbm0db2a3gfwrbbj92yal576wpmhhchc0w0np8vdnax70n";
  };

  checkInputs = stdenv.lib.optionals doCheck [ pytest pytest_xdist flake8 flaky ];
  propagatedBuildInputs = stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  inherit doCheck;

  # https://github.com/DRMacIver/hypothesis/issues/300
  checkPhase = ''
    rm tox.ini # This file changes how py.test runs and breaks it
    py.test tests/cover
  '';

  # Unsupport by upstream on certain versions
  # https://github.com/HypothesisWorks/hypothesis-python/issues/477
  disabled = pythonOlder "3.4" && pythonAtLeast "2.8";

  meta = with stdenv.lib; {
    description = "A Python library for property based testing";
    homepage = https://github.com/DRMacIver/hypothesis;
    license = licenses.mpl20;
  };
}
