{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytestCheckHook
, python
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tedder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/SqU/ojP9I4JXzR0c5tLzxx9UyNaVsON7LG/dbdeiH0=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  passthru.optional-dependencies = {
    httpx = [ httpx ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.httpx;

  pythonImportsCheck = [
    "requests_aws4auth"
  ];

  meta = with lib; {
    description = "Amazon Web Services version 4 authentication for the Python Requests library";
    homepage = "https://github.com/sam-washington/requests-aws4auth";
    license = licenses.mit;
    maintainers = with maintainers; [ basvandijk ];
  };
}
