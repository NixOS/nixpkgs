{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil }:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a558d3b7b6ce7ffc74206a86c147052de23d3d4ef0e17c210dd478c53575c4cd";
  };

  checkPhase = ''
    nosetests --cover-package=arrow
  '';

  checkInputs = [ nose chai simplejson ];
  propagatedBuildInputs = [ dateutil backports_functools_lru_cache ];

  postPatch = ''
    substituteInPlace setup.py --replace "==1.2.1" ""
  '';

  meta = with stdenv.lib; {
    description = "Python library for date manipulation";
    license     = "apache";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
