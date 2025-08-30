{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rubicon-objc";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "rubicon-objc";
    tag = "v${version}";
    hash = "sha256-HnPp7VUrcTfkl5XdXYasydMqxhp7eb7r5RW/7yRWmko=";
  };

  postPatch = ''
    sed -i 's/"setuptools==.*"/"setuptools"/' pyproject.toml
    sed -i 's/"setuptools_scm==.*"/"setuptools_scm"/' pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  preCheck = ''
    make -C tests/objc
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rubicon.objc" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Bridge interface between Python and Objective-C";
    homepage = "https://github.com/beeware/rubicon-objc/";
    changelog = "https://github.com/beeware/rubicon-objc/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.darwin;
  };
}
