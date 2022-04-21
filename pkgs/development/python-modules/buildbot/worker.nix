{ lib
, buildPythonPackage
, fetchPypi
, buildbot

# patch
, coreutils

# propagates
, autobahn
, future
, msgpack
, twisted

# tests
, mock
, parameterized
, psutil
, setuptoolsTrial

# passthru
, nixosTests
}:

buildPythonPackage (rec {
  pname = "buildbot-worker";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HZH3TdH5dhr3f6ev25O3SgPPNbiFGMmAp9DHwcb/2MA=";
  };

  postPatch = ''
    substituteInPlace buildbot_worker/scripts/logwatcher.py \
      --replace /usr/bin/tail "${coreutils}/bin/tail"
  '';

  nativeBuildInputs = [
    setuptoolsTrial
  ];

  propagatedBuildInputs = [
    autobahn
    future
    msgpack
    twisted
  ];

  checkInputs = [
    mock
    parameterized
    psutil
  ];

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
