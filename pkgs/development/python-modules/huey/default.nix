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
  version = "2.5.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "huey";
    tag = version;
    hash = "sha256-Avy5aMYoeIhO7Q83s2W4o6RBMaVFdRBqa7HGNIGNOqE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ redis ];

  # connects to redis
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/coleifer/huey/blob/${src.tag}/CHANGELOG.md";
    description = "Little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = licenses.mit;
    maintainers = [ ];
  };
}
