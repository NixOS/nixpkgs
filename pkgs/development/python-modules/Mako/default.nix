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
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27";
  };

  checkInputs = [ markupsafe nose mock ];
  propagatedBuildInputs = [ markupsafe ];

  doCheck = !isPyPy;  # https://bitbucket.org/zzzeek/mako/issue/238/2-tests-failed-on-pypy-24-25
  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Super-fast templating language";
    homepage = "https://www.makotemplates.org/";
    changelog = "https://docs.makotemplates.org/en/latest/changelog.html";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
  };
}
