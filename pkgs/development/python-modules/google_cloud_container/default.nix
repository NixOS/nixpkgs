{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, google_api_core
, grpc_google_iam_v1, libcst, mock, proto-plus, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dcd8084dd55c0439ff065d3fb206e2e5c695d3a25effd774b74f8ce43afc911";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ mock pytest pytest-asyncio ];
  propagatedBuildInputs =
    [ google_api_core grpc_google_iam_v1 libcst proto-plus ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/python-container";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
