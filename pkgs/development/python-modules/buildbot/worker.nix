{ lib, buildPythonPackage, fetchPypi, python, setuptoolsTrial, mock, twisted, future }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14qimaf513h2hklcpix8vscrawvr1qiyn1vy88ycpsbz9mcqbhps";
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
