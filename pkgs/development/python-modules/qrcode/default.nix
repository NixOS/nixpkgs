{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pillow
, pypng
, typing-extensions
, mock
, pytestCheckHook
<<<<<<< HEAD
, testers
, qrcode
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "7.4.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ndlpRUgn4Sfb2TaWsgdHI55tVA4IKTfJDxSslbMPWEU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
    pypng
<<<<<<< HEAD
    # imports pkg_resouces in console_scripts.py
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  passthru.optional-dependencies.pil = [
    pillow
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pil;

<<<<<<< HEAD
  passthru.tests = {
    version = testers.testVersion {
      package = qrcode;
      command = "qr --version";
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python QR Code image generator";
    homepage = "https://github.com/lincolnloop/python-qrcode";
    changelog = "https://github.com/lincolnloop/python-qrcode/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
  };

}
