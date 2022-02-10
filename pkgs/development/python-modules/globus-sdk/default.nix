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
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = version;
    sha256 = "12zza78qydkgzqg3j9428g92v7bb55nrwvl5m2il96z39darh7v8";
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
