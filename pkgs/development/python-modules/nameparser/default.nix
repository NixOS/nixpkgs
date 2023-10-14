{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qiQArXHM+AcGdbQDEaJXyTRln5GFSxVOG6bCZHYcBJ0=";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    license = licenses.lgpl21Plus;
  };

}
