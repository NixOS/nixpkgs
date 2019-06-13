{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f54d9f016c0b7811fac9fb8c2c7fa7421d80c54dbdd75ffb12913c55db60b8a";
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
