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
  version = "1.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5a642d8c5699269ab62a68b296ff990767eb120f51e2e8f3d6afb16bdb57f4b";
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
