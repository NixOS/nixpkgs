{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lincolnloop";
    repo = "python-qrcode";
    tag = "v${version}";
    hash = "sha256-qLIYUFnBJQGidnfC0bQAkO/aUmT94uXFMeMhnUgUnfQ=";
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

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

  meta = {
    description = "Python QR Code image generator";
    mainProgram = "qr";
    homepage = "https://github.com/lincolnloop/python-qrcode";
    changelog = "https://github.com/lincolnloop/python-qrcode/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ attila ];
  };
}
