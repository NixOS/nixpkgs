{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  twisted,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mpd2";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "python-mpd2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3isX3e4Fu1orxuRsC3u8RxoFDQcE4XxQhf8PIHdo/e4=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    twisted = [ twisted ];
  };

  nativeCheckInputs = [ unittestCheckHook ] ++ finalAttrs.passthru.optional-dependencies.twisted;

  meta = {
    changelog = "https://github.com/Mic92/python-mpd2/blob/${finalAttrs.src.tag}/doc/changes.rst";
    description = "Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      mic92
      hexa
    ];
  };
})
