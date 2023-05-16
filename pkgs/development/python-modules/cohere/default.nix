{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchpatch
, fetchPypi
, poetry-core
, pythonOlder
, aiohttp
, backoff
, fastavro
, importlib-metadata
, requests
=======
, fetchPypi
, poetry-core
, pythonOlder
, requests
, aiohttp
, backoff
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cohere";
<<<<<<< HEAD
  version = "4.21";
=======
  version = "4.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-9hFDj0Cd/F1aChU6WFNJ9agLFpxxArWZTZmZ7PhECGY=";
  };

  patches = [
    # https://github.com/cohere-ai/cohere-python/pull/289
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/cohere-ai/cohere-python/commit/e86480336331c0cf6f67e26b0825467dfca5b277.patch";
      hash = "sha256-P1Ioq5ypzT3tx6cxrI3ep34Fi4cUx88YkfJ5ErN3VHk=";
    })
  ];

=======
    hash = "sha256-koIDk7JPKb8lhBkwaX/o76AuaNrFaeapVp54RRxEY9U=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiohttp
    backoff
    fastavro
    importlib-metadata
    requests
=======
    requests
    aiohttp
    backoff
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # tests require CO_API_KEY
  doCheck = false;

  pythonImportsCheck = [
    "cohere"
  ];

  meta = with lib; {
    description = "Simplify interfacing with the Cohere API";
    homepage = "https://docs.cohere.com/docs";
    changelog = "https://github.com/cohere-ai/cohere-python/blob/main/CHANGELOG.md#${builtins.replaceStrings ["."] [""] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
