{ buildPythonPackage
, fetchPypi
, lib
, six
, attrs
, pytest
, testtools
}:
buildPythonPackage rec {
  version = "0.11.0";
  pname = "effect";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q75w4magkqd8ggabhhzzxmxakpdnn0vdg7ygj89zdc9yl7561q6";
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
    pytest .
  '';
  meta = with lib; {
    description = "Pure effects for Python";
    homepage = https://github.com/python-effect/effect;
    license = licenses.mit;
  };
}
