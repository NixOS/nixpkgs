{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mpv-jsonipc";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-drXPu355wXznB9oTF2mmjXoByLs1gzUuBxWT6wUFMTA=";
  };

  build-system = [ setuptools ];

  # 'mpv-jsonipc' does not have any tests
  doCheck = false;

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
