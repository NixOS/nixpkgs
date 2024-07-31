{
  lib,
  buildPythonPackage,
  darwin,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rubicon-objc";
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "rubicon-objc";
    rev = "refs/tags/v${version}";
    hash = "sha256-jQ/q2yIXJp+X4ajcbEqxXuYtYeyZJ1xTBjSlzqLuRpg=";
  };

  relaxBuildSystem = [
    "setuptools"
    "setuptools_scm"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  preCheck = ''
    make -C tests/objc
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  checkInputs = [ darwin.apple_sdk.frameworks.Foundation ];

  pythonImportsCheck = [ "rubicon.objc" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Bridge interface between Python and Objective-C";
    homepage = "https://github.com/beeware/rubicon-objc/";
    changelog = "https://github.com/beeware/rubicon-objc/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.darwin;
  };
}
