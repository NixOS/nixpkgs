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
    sha256 = "b2444dbfd03deda35792bd00ebd1692597c2605c61445da79da6322afaca7a8d";
  };

  propagatedBuildInputs = [
    flask
    six
  ];

  # touches network
  doCheck = false;

  meta = with lib; {
    description = "A framework for writing webhooks for GitHub";
    homepage = "https://github.com/bloomberg/python-github-webhook";
    license = licenses.mit;
  };
}
