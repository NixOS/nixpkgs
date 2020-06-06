{ lib, buildPythonPackage, fetchPypi, setuptoolsTrial, mock, twisted, future,
  coreutils }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19pabha9jh3jnz9micfn5y4khnx4q6g1zc27wvfw6663mw6spykx";
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
