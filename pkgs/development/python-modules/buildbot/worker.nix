{ lib, buildPythonPackage, fetchPypi, python, setuptoolsTrial, mock, twisted, future }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12zvf4c39b6s4g1f2w407q8kkw602m88rc1ggi4w9pkw3bwbxrgy";
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
