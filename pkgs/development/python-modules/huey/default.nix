{ lib, buildPythonPackage, fetchFromGitHub, redis }:

buildPythonPackage rec {
  pname = "huey";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    sha256 = "1hgic7qrmb1kxvfgf2qqiw39nqyknf17pjvli8jfzvd9mv7cb7hh";
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
