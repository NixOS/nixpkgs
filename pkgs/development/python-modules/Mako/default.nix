{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
, nose
, mock
, pytest
, isPyPy
}:

buildPythonPackage rec {
  pname = "Mako";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nchpw6akfcsg8w6irjlx0gyzadc123hv4g47sijgnqd9nz9vngy";
  };

  checkInputs = [ markupsafe nose mock pytest ];
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