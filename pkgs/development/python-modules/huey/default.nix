{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  redis,
}:

buildPythonPackage rec {
  pname = "huey";
  version = "2.6.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "huey";
    tag = version;
    hash = "sha256-vXp8xISf8g1VjIus/Xr4wKFFaVg5x4CXgP8IUUKYl+o=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ redis ];

  # connects to redis
  doCheck = false;

  meta = {
    changelog = "https://github.com/coleifer/huey/blob/${src.tag}/CHANGELOG.md";
    description = "Little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
