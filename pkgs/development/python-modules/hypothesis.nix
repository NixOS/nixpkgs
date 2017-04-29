{ stdenv, buildPythonPackage, fetchFromGitHub, python
, pythonOlder, pythonAtLeast, enum34
, doCheck ? true, pytest, flake8, flaky
}:
buildPythonPackage rec {
  # http://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  name = "hypothesis-${version}";
  version = "3.7.0";

  # Upstream prefers github tarballs
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "${version}";
    sha256 = "1zsv1ggf3g9rrigxl3zd1z8qc6fcj8lmszm8ib1ya4ar6r64x0yz";
  };

  buildInputs = stdenv.lib.optionals doCheck [ pytest flake8 flaky ];
  propagatedBuildInputs = stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  inherit doCheck;

  # https://github.com/DRMacIver/hypothesis/issues/300
  checkPhase = ''
    ${python.interpreter} -m pytest tests/cover
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
