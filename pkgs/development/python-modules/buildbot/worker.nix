{ lib, buildPythonPackage, fetchPypi, python, setuptoolsTrial, mock, twisted, future }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nldf4ws1nrkhbapxiy2s8j9fjfbkhp17c5912p6qy3ximfcfa93";
  };

  propagatedBuildInputs = [ twisted future ];

  checkInputs = [ setuptoolsTrial mock ];

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
  '';

  meta = with lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    license = licenses.gpl2;
  };
})
