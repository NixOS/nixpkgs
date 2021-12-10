{ buildPythonPackage
, cryptography
, fetchFromGitHub
, lib
, pythonOlder
, protobuf
, pycryptodome
, requests
}:

buildPythonPackage rec {
  version = "0.4.4";
  pname = "gpapi";
  disabled = pythonOlder "3.3"; # uses shutil.which(), added in 3.3

  src = fetchFromGitHub {
     owner = "NoMore201";
     repo = "googleplay-api";
     rev = "v0.4.4";
     sha256 = "0rr73wzx3phq9kcx6js8ydlw667wq6nwc747kcmdn1ra6296cyb4";
  };

  # package doesn't contain unit tests
  # scripts in ./test require networking
  doCheck = false;

  pythonImportsCheck = [ "gpapi.googleplay" ];

  propagatedBuildInputs = [ cryptography protobuf pycryptodome requests ];

  meta = with lib; {
    homepage = "https://github.com/NoMore201/googleplay-api";
    license = licenses.gpl3Only;
    description = "Google Play Unofficial Python API";
    maintainers = with maintainers; [ ];
  };
}
