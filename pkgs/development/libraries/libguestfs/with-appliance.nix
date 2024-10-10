{
  pkgs,
  libguestfs-appliance,
  libguestfs,
  qemu,
  symlinkJoin,
  makeWrapper,
  binutils-unwrapped,
  libguestfs-with-appliance,
}:

symlinkJoin rec {
  pname = "libguestfs-with-appliance";
  inherit (libguestfs) version;
  name = "${pname}-${version}";

  paths = [
    libguestfs
    libguestfs-appliance
  ];
  buildInputs = [
    makeWrapper
    binutils-unwrapped
  ];
  postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --suffix LD_LIBRARY_PATH : ${placeholder "out"}/lib/
    done

    sofile=$(realpath $out/lib/libguestfs.so)
    cp --no-preserve=mode "$sofile" .
    copy_sofile=./$(basename "$sofile")

    printf '${placeholder "out"}/lib/guestfs/\x00' > new_guestfs_default_path.bin
    objcopy --update-section guestfs_path_str=new_guestfs_default_path.bin $copy_sofile

    install -m 555  $copy_sofile $out/lib/
  '';
  passthru.tests = libguestfs.passthru.tests // {
    libguestfs-test-tool = pkgs.runCommand "run-libguestfs-test-tool" { } ''
      set -e
      ${libguestfs-with-appliance}/bin/libguestfs-test-tool
      touch $out
    '';
    diskFormat = pkgs.runCommand "format-disk" { } ''
      set -e
      export HOME=$(mktemp -d) # avoid access to /homeless-shelter/.guestfish
      ${qemu}/bin/qemu-img create -f qcow2 disk1.img 10G

      ${libguestfs-with-appliance}/bin/guestfish <<'EOF'
      add-drive disk1.img
      run
      list-filesystems
      part-disk /dev/sda mbr
      mkfs ext2 /dev/sda1
      list-filesystems
      EOF
      touch $out
    '';
  };

  meta = {
    hydraPlatforms = [ ];
    inherit (libguestfs.meta)
      description
      homepage
      license
      maintainers
      platforms
      ;
  };
}
