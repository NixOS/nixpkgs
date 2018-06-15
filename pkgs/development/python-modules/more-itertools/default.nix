{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cadwsr97c80k18if7qy5d8j8l1zj3yhnkm6kbngk0lpl7pxq8ax";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  meta = {
    homepage = https://more-itertools.readthedocs.org;
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}