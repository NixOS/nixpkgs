{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zoM27XRk+nubh0X0i5xi3qa+2TG5lxXKlHk2BUSZIUM=";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    license = licenses.lgpl21Plus;
  };

}
