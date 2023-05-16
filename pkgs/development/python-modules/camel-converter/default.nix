{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "camel-converter";
<<<<<<< HEAD
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sanders41";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-XKtWR9dmSMfqkJYUHDQtWBLG3CHrbrI5lNtPUTShmBE=";
=======
    hash = "sha256-SUuSaQU6o2OtjDNrDcO3nS0EZH2ammEkP7AEp4H5ysI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=camel_converter --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  passthru.optional-dependencies = {
    pydantic = [
      pydantic
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pydantic;

  pythonImportsCheck = [
    "camel_converter"
  ];

<<<<<<< HEAD
  disabledTests = [
    # AttributeError: 'Test' object has no attribute 'model_dump'
    "test_camel_config"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/sanders41/camel-converter";
    changelog = "https://github.com/sanders41/camel-converter/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
