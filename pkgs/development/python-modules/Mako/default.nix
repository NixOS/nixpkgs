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
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae";
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