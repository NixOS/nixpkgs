{ lib
, buildPythonPackage
, fetchFromGitHub
, grpcio
, grpcio-tools
<<<<<<< HEAD
=======
, h2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, httpx
, numpy
, pytestCheckHook
, poetry-core
, pydantic
, pythonOlder
<<<<<<< HEAD
, urllib3
, portalocker
, fastembed
# check inputs
, pytest-asyncio
=======
, typing-extensions
, urllib3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "qdrant-client";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-k+ggx4QyVduqtV4WwHELyQDAHdaGE0bizpG1ie6x7FM=";
=======
    hash = "sha256-rpNTV3VBTND39iW/kve0aG1KJzAIl1whmhH+e6RbOhw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    httpx
    grpcio
<<<<<<< HEAD
    # typing-extensions
    grpcio-tools
    pydantic
    urllib3
    portalocker
  ] ++ httpx.optional-dependencies.http2;
=======
    typing-extensions
    grpcio-tools
    pydantic
    urllib3
    h2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "qdrant_client"
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # tests require network access
  doCheck = false;

  passthru.optional-dependencies = {
    fastembed = [ fastembed ];
  };

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python client for Qdrant vector search engine";
    homepage = "https://github.com/qdrant/qdrant-client";
    changelog = "https://github.com/qdrant/qdrant-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
