{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cogapp";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nedbat";
    repo = "cog";
    tag = "v${version}";
    hash = "sha256-46ojLTu1elNcjmWSKJuGKDG4XETLLnJDIpL2Al6/aX0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "cogapp" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Code generator for executing Python snippets in source files";
    homepage = "https://nedbatchelder.com/code/cog";
    changelog = "https://github.com/nedbat/cog/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovek323 ];
  };
}
