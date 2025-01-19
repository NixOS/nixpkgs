{
  lib,
  buildPythonPackage,
  btrfs-progs,
}:
buildPythonPackage {
  pname = "btrfsutil";
  inherit (btrfs-progs) version src;
  format = "setuptools";

  buildInputs = [ btrfs-progs ];

  preConfigure = ''
    cd libbtrfsutil/python
  '';

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "btrfsutil" ];

  meta = {
    description = "Library for managing Btrfs filesystems";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      raskin
      lopsided98
    ];
  };
}
