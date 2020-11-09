{ buildPythonPackage
, certifi
, fetchPypi
, lib
, python-dateutil
, python-slugify
, six
, slugify
, requests
, tqdm
, urllib3
}:

buildPythonPackage rec {
  pname = "kaggle";
  version = "1.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14rv7qykawnp5f7z0wjzp2if6gznf6q2mvk7qy4vins6nv7ywjj4";
  };

  # The version bounds in the setup.py file are unnecessarily restrictive.
  patchPhase = ''
    substituteInPlace setup.py \
      --replace 'urllib3 >= 1.21.1, < 1.25' 'urllib3'
  '';

  propagatedBuildInputs = [
    certifi
    python-dateutil
    python-slugify
    requests
    six
    slugify
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

  meta = with lib; {
    description = "Official API for https://www.kaggle.com, accessible using a command line tool implemented in Python 3";
    homepage = "https://github.com/Kaggle/kaggle-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ cdepillabout ];
  };
}
