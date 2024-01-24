{ lib
, buildPythonPackage
, fetchFromGitHub
, grpcio
, grpcio-tools
, httpx
, numpy
, pytestCheckHook
, poetry-core
, pydantic
, pythonOlder
, urllib3
, portalocker
, fastembed
# check inputs
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "qdrant-client";
  version = "1.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HQJgiy0tBOdXveNzrJcWcnGZAp9eHu3qRjgONj4aTQg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    httpx
    grpcio
    # typing-extensions
    grpcio-tools
    pydantic
    urllib3
    portalocker
  ] ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [
    "qdrant_client"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # tests require network access
  doCheck = false;

  passthru.optional-dependencies = {
    fastembed = [ fastembed ];
  };

  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
