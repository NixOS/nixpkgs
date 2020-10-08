{ lib, buildPythonPackage, fetchFromGitHub, requests, responses, pytestCheckHook }:

buildPythonPackage rec {
  pname = "openrouteservice";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "GIScience";
    repo = "${pname}-py";
    rev = "v${version}";
    sha256 = "ySXzOQI9NcF1W/otbL7i3AY628/74ZkJjDMQ9ywVEPc=";
  };

  checkInputs = [ pytestCheckHook responses ];

  disabledTests = [
    # touches network
    "test_optimized_waypoints"
    "test_invalid_api_key"
    "test_raise_timeout_retriable_requests"
  ];

  meta = with lib; {
    homepage = "https://github.com/GIScience/openrouteservice-py";
    description = "The Python API to consume openrouteservice(s) painlessly";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
