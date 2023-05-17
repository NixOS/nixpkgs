{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pillow
, pypng
, typing-extensions
, mock
, pytestCheckHook
, testers
, qrcode
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
    # imports pkg_resouces in console_scripts.py
    setuptools
  ];

  passthru.optional-dependencies.pil = [
    pillow
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pil;

  passthru.tests = {
    version = testers.testVersion {
      package = qrcode;
      command = "qr --version";
    };
  };

  meta = with lib; {
    description = "Python QR Code image generator";
    homepage = "https://github.com/lincolnloop/python-qrcode";
    changelog = "https://github.com/lincolnloop/python-qrcode/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
  };

}
