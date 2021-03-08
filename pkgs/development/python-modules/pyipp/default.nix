{ lib
, aiohttp
, aresponses
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytestcov
, yarl
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.11.0";

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = version;
   sha256 = "0ar3mkyfa9qi3av3885bvacpwlxh420if9ymdj8i4x06ymzc213d";
  };

  propagatedBuildInputs = [
    aiohttp
    deepmerge
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestcov
    pytestCheckHook
  ];

  # Some tests are failing due to encoding issues
  # https://github.com/ctalkington/python-ipp/issues/121
  disabledTests = [
    "test_internal_session"
    "test_request_port"
    "est_http_error426"
    "test_unexpected_response"
    "test_printer"
    "test_raw"
    "test_ipp_request"
    "test_request_tls"
    "test_ipp_error_0x0503"
  ];

  pythonImportsCheck = [ "pyipp" ];

  meta = with lib; {
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
