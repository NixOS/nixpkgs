{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  libclang,
  sphinx,
  clang,
  pytestCheckHook,
  strictyaml,
}:

buildPythonPackage rec {
  pname = "hawkmoth";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jnikula";
    repo = "hawkmoth";
    tag = "v${version}";
    hash = "sha256-ePi7whsibStYwG75Eso7A0GkSbn8JesacaDU5IRF9iE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    libclang
    sphinx
  ];
  propagatedBuildInputs = [ clang ];

  nativeCheckInputs = [
    clang
    pytestCheckHook
    strictyaml
  ];
  pythonImportsCheck = [ "hawkmoth" ];

  meta = {
    description = "Sphinx Autodoc for C";
    homepage = "https://jnikula.github.io/hawkmoth/";
    changelog = "https://github.com/jnikula/hawkmoth/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.cynerd ];
  };
}
