{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  responses,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openrouteservice";
  version = "2.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GIScience";
    repo = "${pname}-py";
    rev = "v${version}";
    hash = "sha256-WHzujUc28D37m26rZNPvhew+MgpBhdocv9AFtJ5fuLQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # touches network
    "test_optimized_waypoints"
    "test_invalid_api_key"
    "test_raise_timeout_retriable_requests"
  ];

  meta = {
    homepage = "https://github.com/GIScience/openrouteservice-py";
    description = "Python API to consume openrouteservice(s) painlessly";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}
