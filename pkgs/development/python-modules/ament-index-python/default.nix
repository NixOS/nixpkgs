{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  pytestCheckHook,
  ament-copyright,
  ament-flake8,
  ament-mypy,
  ament-pep257,
  ament-xmllint,
  argcomplete,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-index-python";
  version = "1.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_index";
    tag = finalAttrs.version;
    hash = "sha256-1jvzvUMrGEcGbc+B2dZZSNpX/7NOMQUjgnk1m+cePSA=";
  };

  sourceRoot = "${finalAttrs.src.name}/ament_index_python";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    ament-copyright
    ament-flake8
    ament-mypy
    ament-pep257
    ament-xmllint
    argcomplete
  ];

  # avoid 'Duplicate module named "ament_index_python"'
  # because ament_index_python/__init__.py + build/lib/ament_index_python/__init__.py
  preCheck = ''
    touch build/AMENT_IGNORE
  '';

  meta = {
    description = "Python API to access the ament resource index";
    homepage = "https://github.com/ament/ament_index";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "ament_index";
    platforms = lib.platforms.all;
  };
})
