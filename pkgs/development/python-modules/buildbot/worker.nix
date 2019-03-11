{ lib, buildPythonPackage, fetchPypi, python, setuptoolsTrial, mock, twisted, future }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rh73jbyms4b9wgkkdzcn80xfd18p8rn89rw4rsi2002ydrc7n39";
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
