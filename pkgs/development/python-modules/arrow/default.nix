{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82dd5e13b733787d4eb0fef42d1ee1a99136dc1d65178f70373b3678b3181bfc";
  };

  checkPhase = ''
    nosetests --cover-package=arrow
  '';

  checkInputs = [ nose chai simplejson pytz ];
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
