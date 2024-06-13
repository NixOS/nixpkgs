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
  version = "2.5.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-t767eqZ6U12mG8nWEYC9Hoq/jW2yfrPkCxB3/xLKQww=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ redis ];

  # connects to redis
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/coleifer/huey/blob/${src.rev}/CHANGELOG.md";
    description = "Little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = licenses.mit;
    maintainers = [ ];
  };
}
