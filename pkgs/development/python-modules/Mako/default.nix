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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b";
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
