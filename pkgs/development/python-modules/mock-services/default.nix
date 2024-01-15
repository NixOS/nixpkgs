{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, attrs
, funcsigs
, requests-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mock-services";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "peopledoc";
    repo = "mock-services";
    rev = version;
    sha256 = "1rqyyfwngi1xsd9a81irjxacinkj1zf6nqfvfxhi55ky34x5phf9";
  };

  patches = [
    # Fix issues due to internal API breaking in latest versions of requests-mock
    (fetchpatch {
      url = "https://github.com/peopledoc/mock-services/commit/88d3a0c9ef4dd7d5e011068ed2fdbbecc4a1a03a.patch";
      sha256 = "0a4pwxr33kr525sp8q4mb4cr3n2b51mj2a3052lhg6brdbi4gnms";
    })
  ];

  propagatedBuildInputs = [
    attrs
    funcsigs
    requests-mock
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require networking
    "test_real_http_1"
    "test_restart_http_mock"
    "test_start_http_mock"
    "test_stop_http_mock"
  ];

  pythonImportsCheck = [ "mock_services" ];

  meta = with lib; {
    description = "Mock an entire service API based on requests-mock";
    homepage = "https://github.com/peopledoc/mock-services";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
