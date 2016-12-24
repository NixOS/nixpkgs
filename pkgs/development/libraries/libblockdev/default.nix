{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python3Packages, glib
, gobjectIntrospection, cryptsetup, nss, nspr, devicemapper, udev, kmod, parted
# Dependencies NOT checked by the configure script:
, volume_key, dmraid, libuuid, gtkdoc, docbook_xsl, libxslt, libbytesize
# Dependencies needed for patching in executable paths:
, utillinux, btrfs-progs, lvm2, bcache-tools, mdadm, mpathconf, multipath-tools
, gptfdisk, e2fsprogs, dosfstools, xfsprogs
}:

let
  # Paths to program binaries that we need to patch into the source:
  binPaths = {
    BTRFS = "${btrfs-progs}/bin/btrfs";
    DMSETUP = "${devicemapper}/bin/dmsetup";
    DUMPE2FS = "${e2fsprogs}/bin/dumpe2fs";
    E2FSCK = "${e2fsprogs}/bin/e2fsck";
    FATLABEL = "${dosfstools}/bin/fatlabel";
    FSCK_VFAT = "${dosfstools}/bin/fsck.vfat";
    LOSETUP = "${utillinux}/bin/losetup";
    LVM = "${lvm2}/bin/lvm";
    MAKE_BCACHE = "${bcache-tools}/bin/make-bcache";
    MDADM = "${mdadm}/bin/mdadm";
    MKFS_BTRFS = "${btrfs-progs}/bin/mkfs.btrfs";
    MKFS_EXT4 = "${e2fsprogs}/bin/mkfs.ext4";
    MKFS_VFAT = "${dosfstools}/bin/mkfs.vfat";
    MKFS_XFS = "${xfsprogs}/bin/mkfs.xfs";
    MKSWAP = "${utillinux}/bin/mkswap";
    MPATHCONF = "${mpathconf}/bin/mpathconf";
    MULTIPATH = "${multipath-tools}/bin/multipath";
    RESIZE2FS = "${e2fsprogs}/bin/resize2fs";
    SFDISK = "${utillinux}/bin/sfdisk";
    SGDISK = "${gptfdisk}/bin/sgdisk";
    SWAPOFF = "${utillinux}/bin/swapoff";
    SWAPON = "${utillinux}/bin/swapon";
    TUNE2FS = "${e2fsprogs}/bin/tune2fs";
    XFS_ADMIN = "${xfsprogs}/bin/xfs_admin";
    XFS_DB = "${xfsprogs}/bin/xfs_db";
    XFS_GROWFS = "${xfsprogs}/bin/xfs_growfs";
    XFS_INFO = "${xfsprogs}/bin/xfs_info";
    XFS_REPAIR = "${xfsprogs}/bin/xfs_repair";
  };

  # Create a shell script fragment to check whether a particular path exists.
  mkBinCheck = prog: path: let
    inherit (stdenv.lib) escapeShellArg;
  in ''
    echo -n ${escapeShellArg "Checking if ${prog} (${path}) exists..."} >&2
    if [ -e ${escapeShellArg path} ]; then
      echo ' yes.' >&2
    else
      echo ' no!' >&2
      exit 1
    fi
  '';

in stdenv.mkDerivation rec {
  name = "libblockdev-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "libblockdev";
    rev = "${name}-1";
    sha256 = "17q07bvh61l0d9iq9y30fgsa4yigsxkp4b93c6dyb7p1nzmb2085";
  };

  patches = [ ./bin-paths.patch ];

  outputs = [ "out" "tests" ];

  postPatch = ''
    patchShebangs .
    sed -i -e 's,/usr/include/volume_key,${volume_key}/include/volume_key,' \
      src/plugins/Makefile.am
    sed -i -e 's,^#define *DEFAULT_CONF_DIR_PATH *",&'"$out"',' \
      src/lib/blockdev.c.in
    sed -i -e 's/python3-pylint/pylint/' Makefile.am
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtkdoc docbook_xsl libxslt python3Packages.pylint
  ];

  buildInputs = [
    (volume_key.override { inherit (python3Packages) python; })
    parted libbytesize python3Packages.python glib gobjectIntrospection
    cryptsetup nss nspr devicemapper udev kmod dmraid libuuid
  ];

  propagatedBuildInputs = [ python3Packages.pygobject3 ];

  NIX_CFLAGS_COMPILE = let
    mkDefine = prog: path: "-D${prog}_BIN_PATH=\"${path}\"";
  in stdenv.lib.mapAttrsToList mkDefine binPaths;

  # Note that real tests are run as a subtest in nixos/tests/blivet.
  doCheck = true;

  checkPhase = let
    checkList = stdenv.lib.mapAttrsToList mkBinCheck binPaths;
  in stdenv.lib.concatStrings checkList;

  postInstall = ''
    sed -i -e 's,^ *sonames *= *,&'"$out/lib/"',' \
      "$out/etc/libblockdev/conf.d/"*
    cp -Rd tests "$tests"
  '';

  meta = {
    homepage = "https://github.com/rhinstaller/libblockdev";
    description = "A library for low-level manipulation of block devices";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
