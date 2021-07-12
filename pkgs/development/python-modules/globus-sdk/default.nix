{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pyjwt
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = version;
    sha256 = "1kqnr50iwcq9nx40lblbqzf327cdcbkrir6vh70067hk33rq0gm9";
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.py \
    --replace "pyjwt[crypto]>=1.5.3,<2.0.0" "pyjwt[crypto] >=1.5.3, <3.0.0"
  '';

  pythonImportsCheck = [ "globus_sdk" ];

  meta = with lib; {
    description = "A convenient Pythonic interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage =  "https://github.com/globus/globus-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
