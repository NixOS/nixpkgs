{ lib
, buildPythonPackage
, fetchFromGitHub

# propagates
, blinker
, cryptography
, pyjwt

# test
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "oauthlib";
  version = "3.1.1";
  format = "setuptools";

  # master supports pyjwt==1.7.1
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256:1bgxpzh11i0x7h9py3a29cz5z714b3p498b62znnn5ciy0cr80sv";
  };

  propagatedBuildInputs = [
    blinker
    cryptography
    pyjwt
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/idan/oauthlib";
    description = "A generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    maintainers = with maintainers; [ prikhi ];
    license = licenses.bsd3;
  };
}
