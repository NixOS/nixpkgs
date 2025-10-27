{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  parted,
  util-linux,
  dosfstools,
  exfatprogs,
  e2fsprogs,
  ntfs3g,
  btrfs-progs,
  xfsprogs,
  jfsutils,
  f2fs-tools,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tparted";
  version = "2025-10-10";

  src = fetchurl {
    url = "https://github.com/Kagamma/tparted/releases/download/${finalAttrs.version}/linux_x86-64_tparted_${finalAttrs.version}.tar.gz";
    hash = "sha256-eLeo+6AGUghrU5szkUFNcieQPA3D/D5pjZV4ZrINiGY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/tparted \
      --prefix PATH : ${
        lib.makeBinPath [
          parted
          util-linux
          dosfstools
          exfatprogs
          e2fsprogs
          ntfs3g
          btrfs-progs
          xfsprogs
          jfsutils
          f2fs-tools
        ]
      }
  '';

  runtimeDependencies = [
    parted
    util-linux
    dosfstools
    exfatprogs
    e2fsprogs
    ntfs3g
    btrfs-progs
    xfsprogs
    jfsutils
    f2fs-tools
  ];

  unpackPhase = ''
    runHook preUnpack
    tar xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tparted $out/bin/
    mkdir -p $out/opt/tparted
    cp -r locale $out/opt/tparted/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Text-based user interface (TUI) frontend for parted";
    homepage = "https://github.com/Kagamma/tparted";
    changelog = "https://github.com/Kagamma/tparted/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ liberodark ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "tparted";
  };
})
