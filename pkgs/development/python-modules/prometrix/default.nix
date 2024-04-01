{ lib
, buildPythonPackage
, fetchFromGitHub
, boto3
, botocore
, dateparser
, matplotlib
, numpy
, pandas
, poetry-core
, prometheus-api-client
, pydantic_1
, requests
}:

buildPythonPackage rec {
  pname = "prometrix";
  version = "unstable-2024-02-20";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "prometrix";
    rev = "ab2dad2192ed3df91c1a25446a4f54b8f2f6742f";
    hash = "sha256-/72Qkd2BojYgiQi5rq7dVsEje7M0aQQXhenvIM7lSy4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'pydantic = "^1.8.1"' 'pydantic = "*"'
  '';

  propagatedBuildInputs = [
    boto3
    botocore
    dateparser
    matplotlib
    numpy
    pandas
    prometheus-api-client
    pydantic_1
    requests
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "prometrix"
  ];

  meta = with lib; {
    description = "Unified Prometheus client";
    longDescription = ''
      This Python package provides a unified Prometheus client that can be used
      to connect to and query various types of Prometheus instances.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
