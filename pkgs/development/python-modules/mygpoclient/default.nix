{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  minimock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mygpoclient";
  version = "1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "mygpoclient";
    tag = version;
    hash = "sha256-g4iPw6i8Gy3kvIjHCyGLJNHNb+osaCmc46hIryrodi8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mygpoclient" ];

  nativeCheckInputs = [
    minimock
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "mygpoclient/http_test.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Gpodder.net client library";
    longDescription = ''
      The mygpoclient library allows developers to utilize a Pythonic interface
      to the gpodder.net web services.
    '';
    homepage = "https://github.com/gpodder/mygpoclient";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
