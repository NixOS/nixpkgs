{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, defusedxml
}:

buildPythonPackage rec {
  pname = "Py3AMF";
  version = "0.8.10";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bawtNKCdr1NR5lTozcMCazVgpttJjBfNzIQyKzFJlSw=";
  };

  propagatedBuildInputs = [ defusedxml ];

  meta = with lib; {
    description = "AMF (Action Message Format) support for Python 3";
    homepage = "https://github.com/StdCarrot/Py3AMF";
    license = licenses.mit;
    maintainers = with maintainers; [ anpandey ];
  };
}
