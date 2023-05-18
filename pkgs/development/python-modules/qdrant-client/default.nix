{ lib
, buildPythonPackage
, fetchFromGitHub
, grpcio
, grpcio-tools
, h2
, httpx
, numpy
, pytestCheckHook
, poetry-core
, pydantic
, pythonOlder
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "qdrant-client";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rpNTV3VBTND39iW/kve0aG1KJzAIl1whmhH+e6RbOhw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    httpx
    grpcio
    typing-extensions
    grpcio-tools
    pydantic
    urllib3
    h2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qdrant_client"
  ];

  disabledTests = [
    # Tests require network access
    "test_conditional_payload_update"
    "test_locks"
    "test_multiple_vectors"
    "test_points_crud"
    "test_qdrant_client_integration"
    "test_quantization_config"
    "test_record_upload"
  ];

  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
