{ lib, buildPythonPackage, fetchPypi, python, mohawk, requests }:

buildPythonPackage rec {
  pname = "requests-hawk";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qcga289yr6qlkmc6fjk0ia6l5cg0galklpdzpslf1y8ky9zb7rl";
  };

  propagatedBuildInputs = [ mohawk requests ];

  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library.";
    homepage = "https://github.com/sam-washington/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
