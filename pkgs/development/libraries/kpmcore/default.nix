{ stdenv, lib, fetchurl, extra-cmake-modules
, qca-qt5, kauth, kio, polkit-qt
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "kpmcore";
  # NOTE: When changing this version, also change the version of `partition-manager`.
  version = "22.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${version}/src/${pname}-${version}.tar.xz";
    hash = "sha256-ZJ179jHCLEB0kFMWfCe+U6c7k7yZ3MztwqAcUd25t40=";
  };

  patches = [
    ./nixostrustedprefix.patch
  ];

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
    substituteInPlace src/backend/corebackend.cpp \
      --replace /usr/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy $out/share/polkit-1/actions/org.kde.kpmcore.externalcommand.policy
  '';

  meta = with lib; {
    description = "KDE Partition Manager core library";
    homepage = "https://invent.kde.org/system/kpmcore";
    license = with licenses; [ cc-by-40 cc0 gpl3Plus mit ];
    maintainers = with maintainers; [ peterhoeg oxalica ];
  };
}
