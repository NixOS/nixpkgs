{ lib, buildPythonPackage, fetchPypi, setuptoolsTrial, mock, twisted, future,
  coreutils }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04dk1jg0yq0rcm7j7pn7l1pqqjhiyvwppnhc1b7106sx2cdj2yb2";
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
