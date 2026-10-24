{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  stdenv,

  libjack2,

  cffi,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage (finalAttrs: {
  pname = "jack-client";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "jackclient-python";
    tag = finalAttrs.version;
    hash = "sha256-SqDHFUlAtGbT/UJALykPvdP7+5KUlZkMpwYDjq+rU98=";
  };

  patches = [
    (replaceVars ./hardcode-jack.patch {
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
      libenv = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      jack = libjack2.outPath;
    })
  ];

  pythonImportsCheck = [ "jack" ];

  build-system = [
    setuptools
    setuptools-scm
    cffi
  ];

  dependencies = [ cffi ];

  meta = {
    description = "JACK Audio Connection Kit (JACK) Client for Python";
    homepage = "https://github.com/spatialaudio/jackclient-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vojtechstep ];
  };
})
