{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rrdtool";
  version = "0.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "commx";
    repo = "python-rrdtool";
    tag = "v${version}";
    hash = "sha256-xBMyY2/lY16H7D0JX5BhgHV5afDKKDObPJnynZ4iZdI=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    pkgs.rrdtool
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
  ];

  pythonImportsCheck = [ "rrdtool" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python bindings for rrdtool";
    homepage = "https://github.com/commx/python-rrdtool";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
