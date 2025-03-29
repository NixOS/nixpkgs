{
  lib,
  pkgs,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  pygobject3,
  libblockdev,
  bytesize,
  pyudev,
  dbus-python,
  util-linux,
  kmod,
  libndctl,
  nvme-cli,
  dosfstools,
  e2fsprogs,
  hfsprogs,
  xfsprogs,
  f2fs-tools,
  ntfs3g,
  btrfs-progs,
  reiserfsprogs,
  mdadm,
  lvm2,
  gfs2-utils,
  cryptsetup,
  multipath-tools,
  dracut,
  stratisd,
}:

let
  libblockdevPython = (libblockdev.override { python3 = python; }).python;
in
buildPythonPackage rec {
  pname = "blivet";
  version = "3.12.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "storaged-project";
    repo = "blivet";
    tag = "blivet-${version}";
    hash = "sha256-ppX2rd1rFkRhca7F56JVQUDEQzW7Cg8ifV60URs2IMY=";
  };

  postPatch = ''
    find blivet -name '*.py' | while IFS= read -r i ; do
      substituteInPlace "$i" \
        --replace \
          'gi.require_version("BlockDev",' \
          'import gi.repository
    gi.require_version("GIRepository", "2.0")
    from gi.repository import GIRepository
    GIRepository.Repository.prepend_search_path("${libblockdev}/lib/girepository-1.0")
    gi.require_version("BlockDev",'
    done
  '';

  propagatedBuildInputs = [
    pygobject3
    libblockdevPython
    bytesize
    pyudev
    dbus-python
    util-linux
    kmod
    libndctl
    nvme-cli
    pkgs.systemd
    dosfstools
    e2fsprogs
    hfsprogs
    xfsprogs
    f2fs-tools
    ntfs3g
    btrfs-progs
    reiserfsprogs
    mdadm
    lvm2
    gfs2-utils
    cryptsetup
    multipath-tools
    dracut
    stratisd
  ];

  pythonImportsCheck = [ "blivet" ];

  # Even unit tests require a system D-Bus.
  # TODO: Write a NixOS VM test?
  doCheck = false;

  meta = {
    description = "Python module for system storage configuration";
    homepage = "https://github.com/storaged-project/blivet";
    license = [
      lib.licenses.gpl2Plus
      lib.licenses.lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ cybershadow ];
    platforms = lib.platforms.linux;
  };
}
