{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
  sphinx,
  libclang,
  strictyaml,
  clang,
}:

buildPythonPackage rec {
  pname = "hawkmoth";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jnikula";
    repo = "hawkmoth";
    tag = "v${version}";
    hash = "sha256-W/5CLHIDvm1u2mtCcpT/2ZpnJrwLU3iCuvl2l+o23EY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    sphinx
    libclang
  ];
  propagatedBuildInputs = [ clang ];

  nativeCheckInputs = [
    pytestCheckHook
    strictyaml
    clang
  ];
  pytestFlags = [ "--rootdir=test" ];
  pythonImportsCheck = [ "hawkmoth" ];

  meta = {
    description = "Sphinx Autodoc for C";
    homepage = "https://jnikula.github.io/hawkmoth/";
    changelog = "https://github.com/jnikula/hawkmoth/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.cynerd ];
  };
}
