{ buildPythonPackage, fetchPypi, requests, lib }:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35547502bf1958044716a03a2f47092a89efe8f9789ab0c4c528d9c9c30bc148";
  };

  propagatedBuildInputs = [ requests ];

  # tests are disabled because they require being online
  doCheck = false;

  pythonImportsCheck = [ "requests_futures" ];

  meta = with lib; {
    description = "Asynchronous Python HTTP Requests for Humans using Futures";
    homepage = "https://github.com/ross/requests-futures";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ applePrincess ];
  };
}
