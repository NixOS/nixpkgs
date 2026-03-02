{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
}:
buildPythonPackage rec {
  pname = "gotenberg-client";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "gotenberg-client";
    tag = version;
    hash = "sha256-JYb0+Dj4QowcN+I6MMoWlv+Q5YoK4nfzYB/UNwhnRu8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
  ]
  ++ httpx.optional-dependencies.http2;

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
