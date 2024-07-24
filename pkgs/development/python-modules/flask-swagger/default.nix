{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  pyyaml,
}:

buildPythonPackage rec {
  version = "0.2.14";
  format = "setuptools";
  pname = "flask-swagger";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4085f5bc36df4c20b6548cd1413adc9cf35719b0f0695367cd542065145294d";
  };

  # No Tests
  doCheck = false;

  propagatedBuildInputs = [
    flask
    pyyaml
  ];

  meta = with lib; {
    homepage = "https://github.com/gangverk/flask-swagger";
    license = licenses.mit;
    description = "Extract swagger specs from your flask project";
    mainProgram = "flaskswagger";
    maintainers = with maintainers; [ vanschelven ];
  };
}
