{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  autoPatchelfHook,
  fontconfig,
  libxkbcommon,
  pkg-config,
  libgcc,
  wayland,
}:
rustPlatform.buildRustPackage rec {
  pname = "yofi";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "l4l";
    repo = "yofi";
    rev = "refs/tags/${version}";
    hash = "sha256-cepAZyA4RBgqeF20g6YOlZTM0aRqErw17yuQ3U24UEg=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "bump-time-1.80.0.patch";
      url = "https://github.com/l4l/yofi/commit/438e180bf5132d29a6846e830d7227cb996ade3e.patch";
      hash = "sha256-o/kwQRIG6MASGYnepb96pL1qfI+/CNTqc5maDPjSZXk=";
    })
  ];

  cargoHash = "sha256-GA6rFet0GIYFR/8WsWteMDwVRz/KyyxlFQOz/lNX7Rk=";

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    libgcc
    libxkbcommon
  ];

  appendRunpaths = [
    (lib.makeLibraryPath [
      fontconfig
      wayland
    ])
  ];

  checkFlags = [
    # Fail to run in sandbox environment.
    "--skip=screen::context::test"
  ];

  meta = {
    description = "Minimalist app launcher in Rust";
    homepage = "https://github.com/l4l/yofi";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rayslash ];
    mainProgram = "yofi";
  };
}
