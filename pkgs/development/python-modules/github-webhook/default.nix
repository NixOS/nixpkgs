{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  six,
}:

buildPythonPackage rec {
  pname = "github-webhook";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-skRNv9A97aNXkr0A69FpJZfCYFxhRF2nnaYyKvrKeo0=";
  };

  propagatedBuildInputs = [
    flask
    six
  ];

  # touches network
  doCheck = false;

  meta = with lib; {
    description = "Framework for writing webhooks for GitHub";
    homepage = "https://github.com/bloomberg/python-github-webhook";
    license = licenses.mit;
  };
}
