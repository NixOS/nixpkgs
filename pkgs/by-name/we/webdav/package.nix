{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.4.4";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-8T/CRIVB4jW9kJ26om6fcm/khfzqdYCWbhJIIRZlMC0=";
  };

  vendorHash = "sha256-f/Og0FkuaeUJ4bjqeUXVacIWnp6uiod7s146iKDSMgU=";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
}
