{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  httpx2,
  magika,
  niquests,
  python-magic,
  requests,
}:
buildPythonPackage rec {
  pname = "gotenberg-client";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "gotenberg-client";
    tag = version;
    hash = "sha256-gCwcNEAgNMp9cIPonNfJRX5PBNCYpp54Fi0HDR1Wks8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
  ]
  ++ httpx.optional-dependencies.http2;

  optional-dependencies = {
    httpx = [ httpx ] ++ httpx.optional-dependencies.http2;
    httpx2 = [ httpx2 ] ++ httpx2.optional-dependencies.http2;
    magic = [ python-magic ];
    magika = [ magika ];
    niquests = [ niquests ];
    requests = [ requests ];
  };

  # requires running gotenberg service
  doCheck = false;

  pythonImportsCheck = [ "gotenberg_client" ];

  meta = {
    description = "Python client for interfacing with the Gotenberg API";
    homepage = "https://github.com/stumpylog/gotenberg-client";
    changelog = "https://github.com/stumpylog/gotenberg-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ leona ];
  };
}
