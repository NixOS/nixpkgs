{ lib
, aiohttp
, buildPythonPackage
, dill
, fetchFromGitHub
, fetchpatch
, fsspec
, huggingface-hub
, importlib-metadata
, multiprocess
, numpy
, packaging
, pandas
, pyarrow
, pythonOlder
, requests
, responses
, tqdm
, xxhash
}:

buildPythonPackage rec {
  pname = "datasets";
<<<<<<< HEAD
  version = "2.14.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "2.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-2XC5k546JvqUV4xeL1SRQOHDzItL1CE3bJQMjva3IkY=";
  };

=======
    hash = "sha256-o/LUzRmpM4tjiCh31KoQXzU1Z/p/91uamh7G4SGnxQM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "responses<0.19" "responses"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aiohttp
    dill
    fsspec
    huggingface-hub
    multiprocess
    numpy
    packaging
    pandas
    pyarrow
    requests
    responses
    tqdm
    xxhash
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

<<<<<<< HEAD
  # Tests require pervasive internet access
  doCheck = false;

  # Module import will attempt to create a cache directory
=======
  # Tests require pervasive internet access.
  doCheck = false;

  # Module import will attempt to create a cache directory.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [
    "datasets"
  ];

  meta = with lib; {
    description = "Open-access datasets and evaluation metrics for natural language processing";
    homepage = "https://github.com/huggingface/datasets";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
