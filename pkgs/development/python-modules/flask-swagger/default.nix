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
    hash = "sha256-tAhfW8Nt9MILZUjNFBOtyc81cZsPBpU2fNVCBlFFKU0=";
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
