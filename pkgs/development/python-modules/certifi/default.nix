{ lib
, buildPythonPackage
, cacert
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "certifi";
<<<<<<< HEAD
  version = "2023.05.07";
=======
  version = "2022.12.07";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-certifi";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-KXm0CtuZJL9VgFeY+DV0rdjaKqPQCqcoGPCkeGieTX8=";
=======
    hash = "sha256-r6TJ6YGL0cygz+F6g6wiqBfBa/QKhynZ92C6lHTZ2rI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Add support for NIX_SSL_CERT_FILE
    ./env.patch
  ];

  postPatch = ''
    # Use our system-wide ca-bundle instead of the bundled one
    rm -v "certifi/cacert.pem"
    ln -snvf "${cacert}/etc/ssl/certs/ca-bundle.crt" "certifi/cacert.pem"
  '';

  propagatedNativeBuildInputs = [
    # propagate cacerts setup-hook to set up `NIX_SSL_CERT_FILE`
    cacert
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "certifi"
  ];

  meta = with lib; {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
<<<<<<< HEAD
    maintainers = with maintainers; [ koral ];
=======
    maintainers = with maintainers; [ koral SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
