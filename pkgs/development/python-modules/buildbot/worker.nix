{ lib, buildPythonPackage, fetchPypi, buildbot, twisted, future, autobahn
, msgpack, setuptoolsTrial, mock, psutil, parameterized, coreutils
, nixosTests }:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HZH3TdH5dhr3f6ev25O3SgPPNbiFGMmAp9DHwcb/2MA=";
  };

  propagatedBuildInputs = [ twisted future autobahn msgpack ];

  checkInputs = [ setuptoolsTrial mock psutil parameterized ];

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
