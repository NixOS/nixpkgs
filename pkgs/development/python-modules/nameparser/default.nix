{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbd4831c72426757ec59674a1aad29c40bf411358a6d6e1cdd68002cbcb90d08";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = "https://github.com/derek73/python-nameparser";
    license = licenses.lgpl21Plus;
  };

}
