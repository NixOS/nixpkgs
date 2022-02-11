{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, bcrypt
, pyopenssl
, python-gnupg
, requests
, openssl
}:

buildPythonPackage rec {
  pname = "proton-client";
  version = "0.7.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-python-client";
    rev = version;
    sha256 = "sha256-mhPq9O/LCu3+E1jKlaJmrI8dxbA9BIwlc34qGwoxi5g=";
  };

  propagatedBuildInputs = [
    bcrypt
    pyopenssl
    python-gnupg
    requests
  ];

  buildInputs = [ openssl ];

  # This patch is supposed to indicate where to load OpenSSL library,
  # but it is not working as intended.
  #patchPhase = ''
  #  substituteInPlace proton/srp/_ctsrp.py --replace \
  #    "ctypes.cdll.LoadLibrary('libssl.so.10')" "'${openssl.out}/lib/libssl.so'"
  #'';
  # Regarding the issue above, I'm disabling tests for now
  doCheck = false;

  pythonImportsCheck = [ "proton" ];

  meta = with lib; {
    description = "Python Proton client module";
    homepage = "https://github.com/ProtonMail/proton-python-client";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
