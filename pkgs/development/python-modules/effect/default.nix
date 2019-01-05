{ buildPythonPackage
, fetchPypi
, isPy37
, lib
, six
, attrs
, pytest
, testtools
}:
buildPythonPackage rec {
  version = "0.12.0";
  pname = "effect";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s8zsncq4l0ar2b4dijf8yzrk13x2swr1w2nb30s1p5jd6r24czl";
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
