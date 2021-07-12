{ stdenv, lib, fetchurl, fetchpatch, extra-cmake-modules
, qca-qt5, kauth, kio, polkit-qt, qtbase
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "kpmcore";
  # NOTE: When changing this version, also change the version of `partition-manager`.
  version = "4.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${pname}-${version}.tar.xz";
    hash = "sha256-MvW0CqvFZtzcJlya6DIpzorPbKJai6fxt7nKsKpJn54=";
  };

  patches = [
    # Fix build with `kcoreaddons` >= 5.77.0
    (fetchpatch {
      url = "https://github.com/KDE/kpmcore/commit/07e5a3ac2858e6d38cc698e0f740e7a693e9f302.patch";
      sha256 = "sha256-LYzea888euo2HXM+acWaylSw28iwzOdZBvPBt/gjP1s=";
    })
    # Fix crash when `fstab` omits mount options.
    (fetchpatch {
      url = "https://github.com/KDE/kpmcore/commit/eea84fb60525803a789e55bb168afb968464c130.patch";
      sha256 = "sha256-NJ3PvyRC6SKNSOlhJPrDDjepuw7IlAoufPgvml3fap0=";
    })
  ];

  buildInputs = [
    qca-qt5
    kauth
    kio
    polkit-qt

    util-linux # Needs blkid in configure script (note that this is not provided by util-linux-compat)
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDE Partition Manager core library";
    homepage = "https://invent.kde.org/system/kpmcore";
    license = with licenses; [ cc-by-40 cc0 gpl3Plus mit ];
    maintainers = with maintainers; [ peterhoeg oxalica ];
    # The build requires at least Qt 5.14:
    broken = versionOlder qtbase.version "5.14";
  };
}
