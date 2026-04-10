{
  lib,
  rustPlatform,
  pkg-config,
  udev,
  lvm2,
  fetchFromGitHub,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "thin-provisioning-tools";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hOwW2zda/KdA22A+94A5r2LIezQTZ71eewhkc72u5kI=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
    lvm2
    udev
  ];
  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    lvm2
    udev
  ];

  cargoHash = "sha256-f417GApMA1R7nX75Zkfv28aZskbpTkUHWePX30X22FU=";

  passthru.tests = {
    inherit (nixosTests.lvm2) lvm-thinpool-linux-latest;
  };

  # Uses O_DIRECT, which is not supported on all filesystems.
  # https://github.com/jthornber/thin-provisioning-tools/issues/38
  doCheck = false;

  # required for config compatibility with configs done pre 0.9.0
  # see https://github.com/NixOS/nixpkgs/issues/317018
  postInstall = ''
    ln -s $out/bin/pdata_tools $out/bin/cache_check
    ln -s $out/bin/pdata_tools $out/bin/cache_dump
    ln -s $out/bin/pdata_tools $out/bin/cache_metadata_size
    ln -s $out/bin/pdata_tools $out/bin/cache_repair
    ln -s $out/bin/pdata_tools $out/bin/cache_restore
    ln -s $out/bin/pdata_tools $out/bin/cache_writeback
    ln -s $out/bin/pdata_tools $out/bin/era_check
    ln -s $out/bin/pdata_tools $out/bin/era_dump
    ln -s $out/bin/pdata_tools $out/bin/era_invalidate
    ln -s $out/bin/pdata_tools $out/bin/era_restore
    ln -s $out/bin/pdata_tools $out/bin/thin_check
    ln -s $out/bin/pdata_tools $out/bin/thin_delta
    ln -s $out/bin/pdata_tools $out/bin/thin_dump
    ln -s $out/bin/pdata_tools $out/bin/thin_ls
    ln -s $out/bin/pdata_tools $out/bin/thin_metadata_size
    ln -s $out/bin/pdata_tools $out/bin/thin_repair
    ln -s $out/bin/pdata_tools $out/bin/thin_restore
    ln -s $out/bin/pdata_tools $out/bin/thin_rmap
    ln -s $out/bin/pdata_tools $out/bin/thin_trim
  '';

  meta = {
    homepage = "https://github.com/jthornber/thin-provisioning-tools/";
    description = "Suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
