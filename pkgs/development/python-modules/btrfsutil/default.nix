{
  lib,
  buildPythonPackage,
  btrfs-progs,
  autoreconfHook,
  pkg-config,
  e2fsprogs,
  libuuid,
  zlib,
}:
buildPythonPackage {
  pname = "btrfsutil";
  inherit (btrfs-progs) version src;
  format = "setuptools";

  buildInputs = [
    btrfs-progs
    e2fsprogs
    libuuid
    zlib
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--disable-documentation"
    "--disable-zstd"
    "--disable-lzo"
    "--disable-libudev"
  ];

  preBuild = ''
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
