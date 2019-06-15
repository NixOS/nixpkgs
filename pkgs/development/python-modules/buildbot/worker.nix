{ lib, buildPythonPackage, fetchPypi, python, setuptoolsTrial, mock, twisted, future }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a26c68debb70f15abee307aff7b225e91a2eedca9c8d571212c391e615c36f53";
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
