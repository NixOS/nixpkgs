{ lib, buildPythonPackage, fetchPypi, buildbot, setuptoolsTrial, mock, twisted,
  future, coreutils, nixosTests }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nDP46rLWYXXKJktR6NTWLb0erC6FU8fXe9FAIX+MWuU=";
  };

  propagatedBuildInputs = [ twisted future ];

  checkInputs = [ setuptoolsTrial mock ];

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  passthru.tests = {
    smoke-test = nixosTests.buildbot;
  };

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
})
