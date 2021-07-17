{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, substituteAll
, openssl
, stdenv
, requests
, bcrypt
, python-gnupg
, pyopenssl
}:

buildPythonPackage rec {
  pname = "proton-client";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-python-client";
    rev = version;
    sha256 = "1wm73c9dr5cmw7gm8w36byvaqvhzb6ybvb4g4kx9j1l39h28zdpz";
  };

  patches = [
    # Patches the openssl library path where openssl is loaded
    (substituteAll {
      src = ./openssl-path.patch;
      openssl = openssl.out;
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  propagatedBuildInputs = [ requests bcrypt python-gnupg pyopenssl ];

  pythonImportsCheck = [ "proton.api" ];

  meta = with lib; {
    description = "Proton API Python Client";
    homepage = "https://github.com/ProtonMail/proton-python-client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nkje ];
  };
}
