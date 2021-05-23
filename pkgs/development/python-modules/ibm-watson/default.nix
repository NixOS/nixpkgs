{ lib
, buildPythonPackage
, fetchFromGitHub
, responses
, pytestCheckHook
, python-dotenv
, pytest-rerunfailures
, tox
, requests
, python-dateutil
, websocket_client
, ibm-cloud-sdk-core
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    rev = "v${version}";
    sha256 = "sha256:16llw7kybwndgf2ryrg5698v4j3rhrdx52lf3kdzhxdi0q3kmwdn";
  };

  checkInputs = [
    responses
    pytestCheckHook
    python-dotenv
    pytest-rerunfailures
    tox
  ];

  propagatedBuildInputs = [
    requests
    python-dateutil
    websocket_client
    ibm-cloud-sdk-core
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace websocket-client==0.48.0 websocket-client>=0.48.0 \
      --replace ibm_cloud_sdk_core==3.3.6 ibm_cloud_sdk_core>=3.3.6
  '';

  meta = with lib; {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin lheckemann ];
  };
}
