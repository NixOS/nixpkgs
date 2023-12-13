{ lib, buildPythonPackage, fetchFromGitHub, responses, pytestCheckHook }:

buildPythonPackage rec {
  pname = "openrouteservice";
  version = "2.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GIScience";
    repo = "${pname}-py";
    rev = "v${version}";
    sha256 = "1d5qbygb81fhpwfdm1a118r3xv45xz9n9avfkgxkvw1n8y6ywz2q";
  };

  nativeCheckInputs = [ pytestCheckHook responses ];

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
