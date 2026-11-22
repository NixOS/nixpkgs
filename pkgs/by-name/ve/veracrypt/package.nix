{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeself,
  yasm,
  fuse3,
  wxwidgets_3_2,
  lvm2,
  replaceVars,
  e2fsprogs,
  exfat,
  ntfs3g,
  btrfs-progs,
  pcsclite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veracrypt";
  version = "1.26.31";

  src = fetchFromGitHub {
    owner = "veracrypt";
    repo = "VeraCrypt";
    tag = "VeraCrypt_${finalAttrs.version}";
    hash = "sha256-9lmaXQA2RPXlbOSTfkE5c0UN4FkA05WF2oG2VnvUPyk=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      ext2 = "${e2fsprogs}/bin/mkfs.ext2";
      ext3 = "${e2fsprogs}/bin/mkfs.ext3";
      ext4 = "${e2fsprogs}/bin/mkfs.ext4";
      exfat = "${exfat}/bin/mkfs.exfat";
      ntfs = "${ntfs3g}/bin/mkfs.ntfs";
      btrfs = "${btrfs-progs}/bin/mkfs.btrfs";
    })

    # https://github.com/veracrypt/VeraCrypt/commit/2cca2e1dafa405addc3af8724baf8563f352ac1c
    ./nix-system-paths.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  buildFlags = [ "WITHFUSE3=1" ];

  nativeBuildInputs = [
    makeself
    pkg-config
    yasm
    wrapGAppsHook3
  ];
  buildInputs = [
    fuse3
    lvm2
    wxwidgets_3_2
    pcsclite
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 Main/veracrypt "$out/bin/veracrypt"
    install -Dm444 License.txt -t "$out/share/doc/veracrypt/"
    install -d $out/share/applications

    for size in 16 22 24 32 48 64 128 256 512; do
      install -Dm444 "Resources/Icons/VeraCrypt-''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/veracrypt.png"
    done

    install -Dm444 "Resources/Icons/VeraCrypt.svg" \
      "$out/share/icons/hicolor/scalable/apps/veracrypt.svg"
    install -Dm444 "Resources/Icons/VeraCrypt-symbolic.svg" \
      "$out/share/icons/hicolor/symbolic/apps/veracrypt-symbolic.svg"

    substitute Setup/Linux/veracrypt.desktop $out/share/applications/veracrypt.desktop \
      --replace-fail "Exec=/usr/bin/veracrypt" "Exec=$out/bin/veracrypt"
  '';

  meta = {
    description = "Free Open-Source filesystem on-the-fly encryption";
    homepage = "https://www.veracrypt.fr/";
    license =
      with lib.licenses;
      AND [
        asl20 # and
        unfree # TrueCrypt License version 3.0
      ];
    maintainers = [ lib.maintainers.ryand56 ];
    platforms = lib.platforms.linux;
  };
})
