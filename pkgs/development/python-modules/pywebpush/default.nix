{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  http-ece,
  mock,
  py-vapid,
  pytestCheckHook,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pywebpush";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gmD45C1w7ZWjvQBSf/y0O1s9+Jg6SkiwWf4psG3D2Sw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    http-ece
    py-vapid
    requests
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywebpush" ];

  meta = {
    description = "Webpush Data encryption library for Python";
    homepage = "https://github.com/web-push-libs/pywebpush";
    changelog = "https://github.com/web-push-libs/pywebpush/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "pywebpush";
  };
}
