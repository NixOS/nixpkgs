{ lib, buildPythonPackage, fetchPypi, setuptoolsTrial, mock, twisted, future,
  coreutils }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l2ax9ywrhgrs9f9yyhiq5nhcf34w916ikx6bjcd6f201ixky1xg";
  };

  propagatedBuildInputs = [ twisted future ];

  checkInputs = [ setuptoolsTrial mock ];

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  meta = with lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
})
