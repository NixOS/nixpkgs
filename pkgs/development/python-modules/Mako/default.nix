{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
, nose
, mock
, pytest_3
, isPyPy
}:

buildPythonPackage rec {
  pname = "Mako";
  version = "1.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7165919e78e1feb68b4dbe829871ea9941398178fa58e6beedb9ba14acf63965";
  };

  checkInputs = [ markupsafe nose mock pytest_3 ];
  propagatedBuildInputs = [ markupsafe ];

  doCheck = !isPyPy;  # https://bitbucket.org/zzzeek/mako/issue/238/2-tests-failed-on-pypy-24-25

  meta = {
    description = "Super-fast templating language";
    homepage = http://www.makotemplates.org;
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ domenkozar ];
  };
}
