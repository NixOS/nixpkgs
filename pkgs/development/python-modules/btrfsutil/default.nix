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

  meta = with lib; {
    description = "Library for managing Btrfs filesystems";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      raskin
      lopsided98
    ];
  };
}
