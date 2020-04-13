{ lib, buildPythonPackage, fetchPypi, setuptoolsTrial, mock, twisted, future,
  coreutils }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vwy46acvczgk1hhpsqdwpcw55j4hm5pkw6j01f92axiga8r5jk6";
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
