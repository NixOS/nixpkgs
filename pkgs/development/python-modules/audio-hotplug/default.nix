{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyobjc-framework-CoreAudio,
  pytest-asyncio,
  pytestCheckHook,
  pyudev,
  stdenv,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "audio-hotplug";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "audio-hotplug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xq81AfJ5E8lAk1JohD7/RlEDVRrbi/ScX80nMiRd+dY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.13,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies =
    lib.optionals stdenv.hostPlatform.isLinux [ pyudev ]
    ++ lib.optional stdenv.hostPlatform.isDarwin pyobjc-framework-CoreAudio;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "audio_hotplug" ];

  meta = {
    description = "Wrapper for Auburns' FastNoise Lite noise generation library";
    homepage = "https://github.com/tizilogic/PyFastNoiseLite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
