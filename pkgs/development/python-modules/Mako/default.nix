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
  version = "1.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cfa65de3a835e87eeca6ac856b3013aade55f49e32515f65d999f91a2324162";
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
