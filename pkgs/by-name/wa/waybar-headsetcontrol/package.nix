{
  lib,
  fetchFromGitHub,
  rustPlatform,
  headsetcontrol,
  nix-update-script,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "waybar-headsetcontrol";
  version = "0.1.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Henriklmao";
    repo = "waybar-headsetcontrol";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-GX+/SizxFeyt3UoxKCSJgaqBl/7oD5KZAeXzP+UNX+M=";
  };

  # Next release will include Cargo.lock, so we can remove this once that happens
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/Henriklmao/waybar-headsetcontrol/commit/523ebf9e440167b3206b0b36632095c1cee9810c.patch";
      sha256 = "sha256-dXqlNW4vZLyEwzU0+hjq1ZdOzK1pTW1oAbnNZYRtyl8=";
    })
  ];

  cargoHash = "sha256-FdRNBkjeFB3Pr72Jso99reh6pZkzIQ2DlcI7rzx9fJ4=";

  patches = [
    # update dependencies to match Cargo.lock, remove once next release is out
    (fetchpatch {
      url = "https://github.com/Henriklmao/waybar-headsetcontrol/commit/7e66e4bcfa0ff59cff639799751f8d5020e6b93d.patch";
      sha256 = "sha256-j9MU6rfwHCEXUkXM9Cc9rekdxVhwea+LCudNNSZ1FQw=";
    })
  ];

  postPatch = ''
    # Use the nix store path for headsetcontrol instead of assuming it's in PATH
    substituteInPlace src/main.rs \
      --replace-fail \
       'Command::new("headsetcontrol")' \
       'Command::new("${headsetcontrol}/bin/headsetcontrol")'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple Rust and ratatui based integration of HeadsetControl features into Waybar";
    homepage = "https://github.com/Henriklmao/waybar-headsetcontrol";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "wb-headset";
    maintainers = with lib.maintainers; [ joaosreis ];
  };
})
