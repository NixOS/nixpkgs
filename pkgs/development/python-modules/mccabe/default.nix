{ lib, buildPythonPackage, fetchPypi, pytest, pytest-runner }:

buildPythonPackage rec {
  pname = "mccabe";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NI4CQMM7YLvfTlIxku+RnyjLLD19XHeU90AJKQ8jYyU=";
  };

  buildInputs = [ pytest pytest-runner ];

  meta = with lib; {
    description = "McCabe checker, plugin for flake8";
    homepage = "https://github.com/flintwork/mccabe";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
