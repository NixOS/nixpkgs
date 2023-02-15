{ buildPythonPackage
, fetchPypi
, lib
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "miniful";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZCyfNrh8gbPvwplHN5tbmbjTMYXJBKe8Mg2JqOGHFCk=";
  };

  propagatedBuildInputs = [ numpy scipy ];

  meta = with lib; {
    description = "A minimal fuzzy library";
    homepage = "https://github.com/aresio/miniful";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
