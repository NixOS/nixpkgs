{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c01ec7d0bc093420a45d8b5ea8261a84ba12bff0cabf47cb15b716c5ea8f3d23";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = https://github.com/derek73/python-nameparser;
    license = licenses.lgpl21Plus;
  };

}
