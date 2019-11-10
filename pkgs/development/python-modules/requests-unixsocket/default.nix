{ lib, buildPythonPackage, fetchPypi
, pbr, requests
, pytest, pytestpep8, waitress }:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e5c1a20afc3cf786197ae59c79bcdb0e7565f218f27df5f891307ee8817c1ea";
  };

  nativeBuildInputs = [ pbr ];
  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestpep8 waitress ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = https://github.com/msabramo/requests-unixsocket;
    license = licenses.asl20;
    maintainers = [ maintainers.catern ];
  };
}
