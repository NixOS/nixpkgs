{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79b5f81b9315b03ac3744d12448032490f5028b5117b721775ba97118ecd5e45";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = https://github.com/derek73/python-nameparser;
    license = licenses.lgpl21Plus;
  };

}
