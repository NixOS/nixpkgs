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
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0728c404877cd4ca72c409c0ea372dc5f3b53fa1ad2bb434e1d216c0444ff1fd";
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
