{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  llvmPackages_20,
  libclang,
  sphinx,
  pytestCheckHook,
  strictyaml,
}:
let
  libclang_20 = libclang.override {
    llvmPackages = llvmPackages_20;
  };

in
buildPythonPackage rec {
  pname = "hawkmoth";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jnikula";
    repo = "hawkmoth";
    tag = "v${version}";
    hash = "sha256-iFyTayPC4TWOfTZrfJJILJyi5BWrsVLwnSFnSeMpB2c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    libclang_20
    sphinx
  ];
  propagatedBuildInputs = [ llvmPackages_20.clang ];

  nativeCheckInputs = [
    llvmPackages_20.clang
    pytestCheckHook
    strictyaml
  ];
  pythonImportsCheck = [ "hawkmoth" ];

  meta = {
    description = "Sphinx Autodoc for C";
    homepage = "https://jnikula.github.io/hawkmoth/";
    changelog = "https://github.com/jnikula/hawkmoth/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.cynerd ];
  };
}
