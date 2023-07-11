{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, redis
}:

buildPythonPackage rec {
  pname = "huey";
  version = "2.4.5";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7ZMkA5WzWJKSwvpOoZYQO9JgedCdxNGrkFuPmYm4aRE=";
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
    description = "A little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = licenses.mit;
    maintainers = [ maintainers.globin ];
  };
}
