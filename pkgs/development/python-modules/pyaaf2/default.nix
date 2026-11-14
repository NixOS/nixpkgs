{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-headless,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaaf2";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markreidvfx";
    repo = "pyaaf2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QCieEWVMvObn3kXbXD6B7DSu+yhRXT7/yZBNwPIMZOE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "aaf2" ];

  nativeCheckInputs = [ ffmpeg-headless ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover -s tests -v
    runHook postCheck
  '';

  meta = {
    description = "Module for reading and writing Advanced Authoring Format (AAF) files";
    homepage = "https://github.com/markreidvfx/pyaaf2";
    changelog = "https://github.com/markreidvfx/pyaaf2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thecodedkid ];
  };
})
