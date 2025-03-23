{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  poetry-core,

  # dependencies
  pillow,
  pypng,

  # tests
  mock,
  pytestCheckHook,
  qrcode,
  testers,
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AlzisVD3/kKW0Rbum61FWmZDq09ufc5UFhOkdYy840c=";
  };

  build-system = [ poetry-core ];

  optional-dependencies = {
    pil = [ pillow ];
    png = [ pypng ];
    all = [
      pypng
      pillow
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
    maintainers = [ ];
  };
}
