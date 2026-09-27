{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  attrs,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmake-parser";
  version = "0.9.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "cmake_parser";
    tag = finalAttrs.version;
    hash = "sha256-4hJYlnDOuO+Rs1r9/scWK+BZAU9zSH5BTEvkiS3LUh8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
  ];

  pythonImportsCheck = [
    "cmake_parser"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parse CMake files with Python";
    homepage = "https://github.com/roehling/cmake_parser";
    changelog = "https://github.com/roehling/cmake_parser/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
