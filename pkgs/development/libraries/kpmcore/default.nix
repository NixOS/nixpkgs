{ stdenv, lib, fetchurl, extra-cmake-modules
, qca-qt5, kauth, kio, polkit-qt, qtbase
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "kpmcore";
  # NOTE: When changing this version, also change the version of `partition-manager`.
  version = "22.08.0";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${version}/src/${pname}-${version}.tar.xz";
    hash = "sha256-Ws20hKX2iDdke5yBBKXukVUD4OnLf1OmwlhW+jUXL24=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    qca-qt5
    kauth
    kio
    polkit-qt

    util-linux # Needs blkid in configure script (note that this is not provided by util-linux-compat)
  ];

  dontWrapQtApps = true;

  preConfigure = ''
    substituteInPlace src/util/CMakeLists.txt \
      --replace \$\{POLKITQT-1_POLICY_FILES_INSTALL_DIR\} $out/share/polkit-1/actions
  '';

  meta = with lib; {
    description = "KDE Partition Manager core library";
    homepage = "https://invent.kde.org/system/kpmcore";
    license = with licenses; [ cc-by-40 cc0 gpl3Plus mit ];
    maintainers = with maintainers; [ peterhoeg oxalica ];
    # The build requires at least Qt 5.14:
    broken = versionOlder qtbase.version "5.14";
  };
}
