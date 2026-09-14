{
  fetchpatch,
  lib,
  rustPlatform,
  yabridge,
  makeWrapper,
  wineWow64Packages,
}:

rustPlatform.buildRustPackage {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "${yabridge.src.name}/tools/yabridgectl";

  cargoHash = "sha256-VcBQxKjjs9ESJrE4F1kxEp4ah3j9jiNPq/Kdz/qPvro=";

  patches = [
    # Patch yabridgectl to search for the chainloader through NIX_PROFILES
    ./chainloader-from-nix-profiles.patch

    # Dependencies are hardcoded in yabridge, so the check is unnecessary and likely incorrect
    ./remove-dependency-verification.patch

    (fetchpatch {
      url = "https://github.com/robbert-vdh/yabridge/commit/5151f1c447ba5d0f96d4f27931a0a6582cbf511f.patch";
      sha256 = "sha256-hn4biAxcWewSkx2PlQKWCJWJJ1cJ3KBcRAsL3WRd8hE=";
    })
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/yabridgectl" \
      --prefix PATH : ${
        lib.makeBinPath [
          wineWow64Packages.yabridge # winedump
        ]
      }
  '';

  meta = {
    description = "Small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "${yabridge.src.meta.homepage}/tree/${yabridge.version}/tools/yabridgectl";
    changelog = yabridge.meta.changelog;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = yabridge.meta.platforms;
    mainProgram = "yabridgectl";
  };
}
