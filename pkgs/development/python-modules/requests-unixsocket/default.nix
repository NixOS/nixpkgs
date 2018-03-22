{ lib, buildPythonPackage, fetchPypi
, pbr, requests
, pytest, pytestpep8, waitress }:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k19knydh0fzd7w12lfy18arl1ndwa0zln33vsb37yv1iw9w06x9";
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
