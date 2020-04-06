{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson, backports_functools_lru_cache
, dateutil, pytz, mock, dateparser
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yq2bld2bjxddmg9zg4ll80pb32rkki7xyhgnrqnkxy5w9jf942k";
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
