{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  glibcLocales,
  libpulseaudio,
  pulseaudio,
  pytestCheckHook,
  stdenv,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "libpulse";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "xdegaye";
    repo = "libpulse";
    tag = finalAttrs.version;
    hash = "sha256-y5X7Qld/dLwQYfzEqNYn9IiY/JwJ1TUIX0643m564LE=";
  };

  postPatch = ''
    substituteInPlace libpulse/libpulse_ctypes.py \
      --replace-fail "find_library('pulse')" "'${lib.getLib libpulseaudio}/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  build-system = [ flit-core ];

  nativeCheckInputs = [
    glibcLocales
    pulseaudio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # using pulseaudio as it is easier to setup than pipewire
  preCheck = ''
    mkdir -p $HOME/.config/pulse/
    cp ${pulseaudio}/etc/pulse/* $HOME/.config/pulse/
    pulseaudio --verbose --daemonize=yes
  '';

  disabledTests = [
    # path to lib is patched and which breaks the mocking
    "test_missing_lib"
  ];

  pythonImportsCheck = [ "libpulse" ];

  meta = {
    description = "Asyncio interface to the Pulseaudio and Pipewire pulse library";
    homepage = "https://gitlab.com/xdegaye/libpulse";
    license = lib.licenses.mit;
    mainProgram = "pactl-py";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
})
