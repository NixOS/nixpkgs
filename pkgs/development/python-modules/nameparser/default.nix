{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9LbHwQSNUovWqisnz0KgZEfSsx5FqVsgRJUTB48dhu8=";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    license = licenses.lgpl21Plus;
  };

}
