{ lib, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname = "casttube";
  version = "0.2.1";

  src = fetchFromGitHub {
     owner = "ur1katz";
     repo = "casttube";
     rev = "0.2.1";
     sha256 = "1860cw42qzbqpvmxj4851qnqqgiyd1scyf49g0cd4iz0gzwhfgb0";
  };

  propagatedBuildInputs = [ requests ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Interact with the Youtube Chromecast api";
    homepage = "https://github.com/ur1katz/casttube";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
