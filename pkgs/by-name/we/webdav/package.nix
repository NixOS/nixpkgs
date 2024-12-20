{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-PlxJD2PWJ+/nmzHtfeKmzDgFMVrR9qZasH5OwlkFT44=";
  };

  vendorHash = "sha256-e7db4YIosYES6x8AUmRgnVLezMeWq6ni/ltZ65+zkQk=";

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
