{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz, mock, dateparser
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb5d339f00072cc297d7de252a2e75f272085d1231a3723f1026d1fa91367118";
  };

  checkPhase = ''
    nosetests --cover-package=arrow
  '';

  checkInputs = [ nose chai simplejson pytz ];
  propagatedBuildInputs = [ dateutil backports_functools_lru_cache mock dateparser];

  postPatch = ''
    substituteInPlace setup.py --replace "==1.2.1" ""
  '';

  meta = with stdenv.lib; {
    description = "Python library for date manipulation";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
