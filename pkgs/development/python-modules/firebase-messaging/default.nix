{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# dependencies
, cryptography
, http-ece
, protobuf
, requests

# docs
, sphinx
, sphinxHook
, sphinx-autodoc-typehints
, sphinx-rtd-theme

# tests
, async-timeout
, requests-mock
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "firebase-messaging";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdb9696";
    repo = "firebase-messaging";
    rev = version;
    hash = "sha256-e3Ny3pnAfOpNERvvtE/jqSDIsM+YwLq/hbw753QpJ6o=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    poetry-core
    sphinxHook
  ] ++ passthru.optional-dependencies.docs;

  propagatedBuildInputs = [
    cryptography
    http-ece
    protobuf
    requests
  ];

  passthru.optional-dependencies = {
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  pythonImportsCheck = [
    "firebase_messaging"
  ];

  nativeCheckInputs = [
    async-timeout
    requests-mock
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A library to subscribe to GCM/FCM and receive notifications within a python application";
    homepage = "https://github.com/sdb9696/firebase-messaging";
    changelog = "https://github.com/sdb9696/firebase-messaging/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
