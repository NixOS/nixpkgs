{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ansi2image";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "ansi2image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3nTCWyWfFs1NqUGIvYO3ao9MnOMtrq1fmTihLwSky60=";
  };

  postPatch = ''
    substituteInPlace ansi2image/__meta__.py \
      --replace-fail "__version__ = '0.1.4'" "__version__ = '${finalAttrs.version}'" \
      --replace-fail "__version_tuple__ = version_tuple = (0, 1, 4)" "__version_tuple__ = version_tuple = (${lib.concatStringsSep ", " (lib.splitString "." finalAttrs.version)})"
  '';

  build-system = [ setuptools ];

  dependencies = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansi2image" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Module to convert ANSI text to an image";
    homepage = "https://github.com/helviojunior/ansi2image";
    changelog = "https://github.com/helviojunior/ansi2image/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ansi2image";
  };
})
