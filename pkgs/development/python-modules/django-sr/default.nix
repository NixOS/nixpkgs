{ lib, buildPythonPackage, fetchPypi, django, nose }:

buildPythonPackage rec {
  pname = "django-sr";
  version = "0.0.4";
  format = "setuptools";

  meta = {
    description = "Django settings resolver";
    homepage = "https://github.com/jespino/django-sr";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d3yqppi1q3crcn9nxx58wzm4yw61d5m7435g6rb9wcamr9bi1im";
  };

  buildInputs = [ django nose ];
  propagatedBuildInputs = [ django ];
}
