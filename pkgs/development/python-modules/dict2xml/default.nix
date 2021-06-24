{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfn8n8sb3slwx7ra8m8fbfy65k20h2qxcqfq99hwqrrkgcffihl";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Super simple library to convert a Python dictionary into an xml string";
    homepage = "https://github.com/delfick/python-dict2xml";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
