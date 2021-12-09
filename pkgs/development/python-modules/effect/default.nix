{ buildPythonPackage
, fetchFromGitHub
, lib
, isPy3k
, six
, attrs
, pytest
, testtools
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "effect";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
     owner = "python-effect";
     repo = "effect";
     rev = "1.1.0";
     sha256 = "08c38kj3fs63r4ycwr8kr3hck901bqjmlapx3n699nm1bp39pn8j";
  };

  checkInputs = [
    pytest
    testtools
  ];

  propagatedBuildInputs = [
    six
    attrs
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pure effects for Python";
    homepage = "https://github.com/python-effect/effect";
    license = licenses.mit;
  };
}
