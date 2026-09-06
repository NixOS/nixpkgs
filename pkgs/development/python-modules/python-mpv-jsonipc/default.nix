{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mpv-jsonipc";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i21Pzaidoi2MLb6Le9pA37IRy804MeC0yVV4KONb3mk=";
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
