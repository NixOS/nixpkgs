<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, chardet
, pytestCheckHook
, faker
}:

buildPythonPackage rec {
  pname = "mbstrdecoder";
<<<<<<< HEAD
  version = "1.1.3";
  format = "pyproject";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-GcAxXcCYC2XAE8xu/jdDxjPxkLJzbmvWZ3OgmcvQcmk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    chardet
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    faker
  ];
=======
    hash = "sha256-vLlCS5gnc7NgDN4cEZSxxInzbEq4HXAXmvlVfwn3cSM=";
  };

  propagatedBuildInputs = [ chardet ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ faker ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/thombashi/mbstrdecoder";
    description = "A library for decoding multi-byte character strings";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
