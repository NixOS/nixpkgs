{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  mock,
  pyftdi,
  pyopenssl,
  pyserial,
  pytestCheckHook,
  pythonOlder,
  pyusb,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "alarmdecoder";
  version = "1.13.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nutechsoftware";
    repo = "alarmdecoder";
    tag = version;
    hash = "sha256-dMOC8znhnCAn4fKSnT9Vw1oGzDRN72d6m8RWD1NQ6Ms=";
  };

  patches = [
    (fetchpatch {
      name = "use-setuptools_scm.patch";
      url = "https://github.com/nutechsoftware/alarmdecoder/commit/e9fc6aa76d7925bb61a3c53716f2b6e25c9ca342.patch";
      hash = "sha256-vt48QfbkcwQmMgJckpawENVMselVx17jrCNKkZ+s95k=";
    })
  ];

  postPatch = ''
    substituteInPlace test/test_{ad2,devices,messages}.py \
      --replace-fail assertEquals assertEqual
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    pyftdi
    pyopenssl
    pyserial
    pyusb
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Socket issue, https://github.com/nutechsoftware/alarmdecoder/issues/45
    "test_ssl"
    "test_ssl_exception"
  ];

  pythonImportsCheck = [ "alarmdecoder" ];

  meta = with lib; {
    changelog = "https://github.com/nutechsoftware/alarmdecoder/releases/tag/${src.tag}";
    description = "Python interface for the Alarm Decoder (AD2USB, AD2SERIAL and AD2PI) devices";
    homepage = "https://github.com/nutechsoftware/alarmdecoder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
