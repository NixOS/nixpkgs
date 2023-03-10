{ lib, buildPythonPackage, fetchPypi, python, mohawk, requests }:

buildPythonPackage rec {
  pname = "requests-hawk";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c74bd31b581f6d2b36d575bb537b1f29469509f560f5050339a48195d48929b";
  };

  propagatedBuildInputs = [ mohawk requests ];

  meta = with lib; {
    description = "Hawk authentication strategy for the requests python library.";
    homepage = "https://github.com/mozilla-services/requests-hawk";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
