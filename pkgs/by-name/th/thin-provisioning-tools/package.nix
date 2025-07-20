{
  lib,
  rustPlatform,
  pkg-config,
  udev,
  lvm2,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "thin-provisioning-tools";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    hash = "sha256-gjsURDzA4LRTTgKZPzzTcvTdi1mXx4FkWmyoPcpdPfU=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    udev
    lvm2
  ];

  cargoHash = "sha256-H5GRAZpFl2t/bH8THyPkZq5ptS70XkhSCxQ6ko+0RC8=";

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

  meta = with lib; {
    homepage = "https://github.com/jthornber/thin-provisioning-tools/";
    description = "Suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
