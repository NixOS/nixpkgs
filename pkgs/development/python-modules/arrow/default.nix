{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz, mock, dateparser
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10257c5daba1a88db34afa284823382f4963feca7733b9107956bed041aff24f";
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
    license     = "apache";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
