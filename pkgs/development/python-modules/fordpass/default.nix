{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "fordpass";
  version = "0.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clarkd";
    repo = "fordpass-python";
    rev = version;
    hash = "sha256-Fag+iN7jXKmcZAJyHfLTh66+mgqZtMKqDnsJ1rmmLUQ=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "fordpass" ];

  meta = {
    description = "Python module for the FordPass API";
    mainProgram = "demo.py";
    homepage = "https://github.com/clarkd/fordpass-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
