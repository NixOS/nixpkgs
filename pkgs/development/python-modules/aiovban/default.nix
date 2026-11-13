{
  lib,
  aiovban-pyaudio,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  textual,
  uv-build,
  music-assistant,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovban";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmbest2";
    repo = "aiovban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yPp4+aQGJISTIFI/OoO7+mAR8daEytxrQn21SsFWEyc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.0,<0.11.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ textual ];

  # avoid infinite recursion with aiovban-pyaudio
  doCheck = false;

  nativeCheckInputs = [
    aiovban-pyaudio
    pytestCheckHook
  ]
  ++ aiovban-pyaudio.optional-dependencies.cli;

  pythonImportsCheck = [
    "aiovban"
  ];

  passthru.tests = finalAttrs.finalPackage.overrideAttrs (_: {
    doInstallCheck = true;
  });

  meta = {
    changelog = "https://github.com/wmbest2/aiovban/releases/tag/${finalAttrs.src.tag}";
    description = "Asyncio VBAN Protocol Wrapper";
    homepage = "https://github.com/wmbest2/aiovban";
    license = lib.licenses.mit;
    inherit (music-assistant.meta) maintainers;
  };
})
