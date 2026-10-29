{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyglet,
  pytestCheckHook,
  mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "PyWavefront";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pywavefront";
    repo = "PyWavefront";
    rev = finalAttrs.version;
    hash = "sha256-ci40L2opJ+NYYtaAeX1Y5pzkdK+loFspTriX/xv4KR8=";
  };

  nativeBuildInputs = [ setuptools ];

  optional-dependencies.visualization = [ pyglet ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "pywavefront" ];

  meta = {
    description = "Python library for importing Wavefront .obj files";
    homepage = "https://github.com/pywavefront/PyWavefront";
    changelog = "https://github.com/pywavefront/PyWavefront/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
