{ lib, buildPythonPackage, fetchFromGitHub, redis }:

buildPythonPackage rec {
  pname = "huey";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-7ZMkA5WzWJKSwvpOoZYQO9JgedCdxNGrkFuPmYm4aRE=";
  };

  propagatedBuildInputs = [ redis ];

  # connects to redis
  doCheck = false;

  meta = with lib; {
    description = "A little task queue for python";
    homepage = "https://github.com/coleifer/huey";
    license = licenses.mit;
    maintainers = [ maintainers.globin ];
  };
}
