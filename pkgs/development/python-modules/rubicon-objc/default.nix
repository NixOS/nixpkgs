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
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "beeware";
    repo = "rubicon-objc";
    tag = "v${version}";
    hash = "sha256-ahlsY4eU9n+BRexE4wNVXMcgSiGW7pU25zJif9lGTUs=";
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
