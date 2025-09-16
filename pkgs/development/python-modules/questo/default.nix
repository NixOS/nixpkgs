{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  python-yakh,
  rich,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "questo";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "questo";
    rev = "v${version}";
    hash = "sha256-XCxSH2TSU4YdfyqfLpVSEeDeU1S24C+NezP1IL5qj/4=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    python-yakh
    rich
  ];

  pythonImportsCheck = [
    "questo"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library of extensible and modular CLI prompt elements";
    homepage = "https://github.com/petereon/questo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
