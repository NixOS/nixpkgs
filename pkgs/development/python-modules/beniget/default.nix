{
  lib,
  buildPythonPackage,
  fetchPypi,
  gast,
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dVVLO4rQVTzi9gdifa09lcYMRBGJh1uY4JdSj44jrAw=";
  };

  propagatedBuildInputs = [ gast ];

  meta = {
    description = "Extract semantic information about static Python code";
    homepage = "https://github.com/serge-sans-paille/beniget";
    license = lib.licenses.bsd3;
  };
}
