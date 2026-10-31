{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mpv,
  setuptools,
  stdenvNoCC,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mpv-jsonipc";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+FFj86bOGgt8IMV3SRzFK1zLYvU9T4D5DXVIxYeRro=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ] ++ lib.optional (!stdenvNoCC.hostPlatform.isDarwin) mpv;

  unittestFlags = lib.cli.toCommandLineGNU { } {
    start-directory = "tests";
    verbose = true;
  };

  env.REQUIRE_MPV = !stdenvNoCC.hostPlatform.isDarwin;

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connor-grady ];
  };
})
