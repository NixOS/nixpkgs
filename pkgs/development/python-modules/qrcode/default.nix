{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pillow,
  pypng,
  pytestCheckHook,
  pythonAtLeast,
  qrcode,
  setuptools,
  testers,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "7.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ndlpRUgn4Sfb2TaWsgdHI55tVA4IKTfJDxSslbMPWEU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    typing-extensions
    pypng
    # imports pkg_resouces in console_scripts.py
    setuptools
  ];

  passthru.optional-dependencies.pil = [ pillow ];

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

  disabledTests = lib.optionals (pythonAtLeast "3.12") [ "test_change" ] ++ [
    # Attempts to open a file which doesn't exist in sandbox
    "test_piped"
  ];

  meta = with lib; {
    description = "Python QR Code image generator";
    mainProgram = "qr";
    homepage = "https://github.com/lincolnloop/python-qrcode";
    changelog = "https://github.com/lincolnloop/python-qrcode/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
