{
  lib,
  setproctitle,
  uvloop,
  aiovban,
  buildPythonPackage,
  pyaudio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovban-pyaudio";
  inherit (aiovban) version pyproject src;

  sourceRoot = "${aiovban.src.name}/aiovban_pyaudio";

  build-system = [ setuptools ];

  dependencies = [
    aiovban
    pyaudio
  ];

  pythonImportsCheck = [
    "aiovban_pyaudio"
  ];

  optional-dependencies = {
    cli = [
      setproctitle
      uvloop
    ];
  };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/wmbest2/aiovban/releases/tag/${finalAttrs.src.tag}";
    description = "PyAudio wrapper for aiovban";
    homepage = "https://github.com/wmbest2/aiovban/tree/main/aiovban_pyaudio";
    license = lib.licenses.mit;
    inherit (aiovban.meta) maintainers;
  };
})
