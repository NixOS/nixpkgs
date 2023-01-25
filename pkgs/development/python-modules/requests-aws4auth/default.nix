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
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tedder";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-a3OY0Z5GGr3gYa5m4V6ukqQmjZuqtgZjmLGJxmFOPqU=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  passthru.optional-dependencies = {
    httpx = [
      httpx
    ];
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
    changelog = "https://github.com/tedder/requests-aws4auth/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ basvandijk ];
  };
}
