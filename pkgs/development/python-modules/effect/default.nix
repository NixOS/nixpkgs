{ buildPythonPackage
, fetchPypi
, lib
, six
, attrs
, pytest
, testtools
}:
buildPythonPackage rec {
  version = "1.1.0";
  pname = "effect";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7affb603707c648b07b11781ebb793a4b9aee8acf1ac5764c3ed2112adf0c9ea";
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
    homepage = https://github.com/python-effect/effect;
    license = licenses.mit;
  };
}
