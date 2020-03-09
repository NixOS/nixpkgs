{ lib
, buildPythonPackage
, fetchPypi
, python
, markupsafe
, nose
, mock
, isPyPy
}:

buildPythonPackage rec {
  pname = "Mako";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2984a6733e1d472796ceef37ad48c26f4a984bb18119bb2dbc37a44d8f6e75a4";
  };

  checkInputs = [ markupsafe nose mock ];
  propagatedBuildInputs = [ markupsafe ];

  doCheck = !isPyPy;  # https://bitbucket.org/zzzeek/mako/issue/238/2-tests-failed-on-pypy-24-25
  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    description = "Super-fast templating language";
    homepage = http://www.makotemplates.org;
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
