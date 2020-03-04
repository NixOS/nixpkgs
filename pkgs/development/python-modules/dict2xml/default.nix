{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "dict2xml";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17wsybqq0916i1yh7bpf2cmicldn7d0y2b9mzlgs503fkcpxda5w";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Super simple library to convert a Python dictionary into an xml string";
    homepage = "https://github.com/delfick/python-dict2xml";
    license = licenses.mit;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
