{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  unidecode,
  nose,
  yanc,
}:

buildPythonPackage rec {
  pname = "preggy";
  version = "1.4.4";
  format = "setuptools";

  propagatedBuildInputs = [
    six
    unidecode
  ];
  nativeCheckInputs = [
    nose
    yanc
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JbqAOv3k8171Q6YJFc7S5jSSYjUGTfcXw8s+Tj60Zww=";
  };

  checkPhase = ''
    nosetests .
  '';

  meta = with lib; {
    description = "Assertion library for Python";
    homepage = "http://heynemann.github.io/preggy/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
