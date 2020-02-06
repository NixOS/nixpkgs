{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz, mock, dateparser
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1a318a4c0b787833ae46302c02488b6eeef413c6a13324b3261ad320f21ec1e";
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
