{ lib, buildPythonPackage, fetchPypi, python, mohawk, requests }:

buildPythonPackage rec {
  pname = "requests-hawk";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a5e61cab14627f1b5ba7de0e3fb2b681007ff7b2a49110d504e5cd6d7fd62d6";
  };

  propagatedBuildInputs = [ mohawk requests ];

  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library.";
    homepage = "https://github.com/sam-washington/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
