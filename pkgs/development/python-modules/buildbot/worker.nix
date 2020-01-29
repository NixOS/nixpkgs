{ lib, buildPythonPackage, fetchPypi, setuptoolsTrial, mock, twisted, future,
  coreutils }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hr42fp3sw6c59qahihm9440618z7prwsy4z0ax553zvw47pc22l";
  };

  propagatedBuildInputs = [ twisted future ];

  checkInputs = [ setuptoolsTrial mock ];

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
})
