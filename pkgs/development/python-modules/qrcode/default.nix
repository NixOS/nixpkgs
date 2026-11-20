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
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "qrcode";
  version = "8.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lincolnloop";
    repo = "python-qrcode";
    tag = "v${finalAttrs.version}";
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
    versionCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    description = "Python QR Code image generator";
    mainProgram = "qr";
    homepage = "https://github.com/lincolnloop/python-qrcode";
    changelog = "https://github.com/lincolnloop/python-qrcode/blob/v${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ attila ];
  };
})
