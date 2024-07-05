{
  buildPythonPackage,
  bleach,
  certifi,
  fetchPypi,
  lib,
  python-dateutil,
  python-slugify,
  six,
  requests,
  tqdm,
  urllib3,
}:

buildPythonPackage rec {
  pname = "kaggle";
  version = "1.6.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WDUyveyjyeDK/EkxESxnN7Xmjxh6tZ7nff/fCf3529k=";
  };

  propagatedBuildInputs = [
    bleach
    certifi
    python-dateutil
    python-slugify
    requests
    six
    tqdm
    urllib3
    bleach
  ];

  # Tests try to access the network.
  checkPhase = ''
    export HOME="$TMP"
    mkdir -p "$HOME/.kaggle/"
    echo '{"username":"foobar","key":"00000000000000000000000000000000"}' > "$HOME/.kaggle/kaggle.json"
    $out/bin/kaggle --help > /dev/null
  '';
  pythonImportsCheck = [ "kaggle" ];

  meta = with lib; {
    description = "Official API for https://www.kaggle.com, accessible using a command line tool implemented in Python 3";
    mainProgram = "kaggle";
    homepage = "https://github.com/Kaggle/kaggle-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
