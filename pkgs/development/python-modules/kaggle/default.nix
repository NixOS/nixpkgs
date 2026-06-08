{
  bleach,
  buildPythonPackage,
  certifi,
  fetchPypi,
  hatchling,
  kagglesdk,
  lib,
  packaging,
  python-dateutil,
  python-slugify,
  requests,
  six,
  tqdm,
  urllib3,
  protobuf,
}:

buildPythonPackage rec {
  pname = "kaggle";
  version = "1.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MzXaV1KuKEPDqgUjt6ftkajdVQXBnLQDH51XZRw0YQY=";
  };

  build-system = [ hatchling ];

  pythonRemoveDeps = [
    "black"
    "mypy"
    "types-requests"
    "types-tqdm"
  ];

  dependencies = [
    bleach
    certifi
    kagglesdk
    packaging
    protobuf
    python-dateutil
    python-slugify
    requests
    six
    tqdm
    urllib3
  ];

  # Tests try to access the network.
  checkPhase = ''
    export HOME="$TMP"
    mkdir -p "$HOME/.kaggle/"
    echo '{"username":"foobar","key":"00000000000000000000000000000000"}' > "$HOME/.kaggle/kaggle.json"
    $out/bin/kaggle --help > /dev/null
  '';
  pythonImportsCheck = [ "kaggle" ];

  meta = {
    description = "Official API for https://www.kaggle.com, accessible using a command line tool implemented in Python 3";
    mainProgram = "kaggle";
    homepage = "https://github.com/Kaggle/kaggle-api";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
