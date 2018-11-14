{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7eeeffbf16e263452b17b5f4b544d366c3364e966721f39d490e6c7c8b44b7f";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = https://github.com/derek73/python-nameparser;
    license = licenses.lgpl21Plus;
  };

}
