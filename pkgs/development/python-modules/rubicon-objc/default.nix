{ lib
, stdenv
, buildPythonPackage
, darwin
, fetchPypi
, pythonOlder
, setuptools-scm
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "rubicon-objc";
  version = "0.4.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+qbjc96rk7pwiBNUuIQTe4BAPOePyiOA8YnLM4s1CSY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  preCheck = ''
    pushd tests/objc
    make
    popd
  '';

  nativeCheckInputs = [
    unittestCheckHook
  ];

  checkInputs = [
    darwin.apple_sdk.frameworks.Foundation
  ];

  pythonImportsCheck = [
    "rubicon.objc"
  ];

  meta = {
    description = "A bridge interface between Python and Objective-C";
    homepage = "https://github.com/beeware/rubicon-objc/";
    changelog = "https://github.com/beeware/rubicon-objc/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.darwin;
  };
}
