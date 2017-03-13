{ stdenv, buildPythonPackage, fetchFromGitHub, python
, pythonOlder, enum34
, doCheck ? true, pytest, flake8, flaky
}:
buildPythonPackage rec {
  # http://hypothesis.readthedocs.org/en/latest/packaging.html

  # Hypothesis has optional dependencies on the following libraries
  # pytz fake_factory django numpy pytest
  # If you need these, you can just add them to your environment.

  name = "hypothesis-${version}";
  version = "3.6.1";

  # Upstream prefers github tarballs
  src = fetchFromGitHub {
    owner = "HypothesisWorks";
    repo = "hypothesis";
    rev = "${version}";
    sha256 = "1zwr9g4h4jizbvm2d7fywdpcxmw8i1m85h8g72kizah07gk12aq1";
  };

  buildInputs = stdenv.lib.optionals doCheck [ pytest flake8 flaky ];
  propagatedBuildInputs = stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ];

  inherit doCheck;

  # https://github.com/DRMacIver/hypothesis/issues/300
  checkPhase = ''
    ${python.interpreter} -m pytest tests/cover
  '';

  meta = with stdenv.lib; {
    description = "A Python library for property based testing";
    homepage = https://github.com/DRMacIver/hypothesis;
    license = licenses.mpl20;
  };
}
