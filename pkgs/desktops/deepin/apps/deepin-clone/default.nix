{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qttools,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  libuuid,
  parted,
  partclone,
}:

stdenv.mkDerivation rec {
  pname = "deepin-clone";
  version = "5.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-yxYmRSiw/pjgHftu75S9yx0ZXrWRz0VbU8jPjl4baqQ=";
  };

  postPatch = ''
    substituteInPlace app/{deepin-clone-ionice,deepin-clone-pkexec,com.deepin.pkexec.deepin-clone.policy.tmp} \
      --replace "/usr" "$out"

    substituteInPlace app/src/corelib/ddevicediskinfo.cpp \
      --replace "/sbin/blkid" "${libuuid}/bin/blkid"

    substituteInPlace app/src/corelib/helper.cpp \
      --replace "/bin/lsblk" "${libuuid}/bin/lsblk" \
      --replace "/sbin/sfdisk" "${libuuid}/bin/sfdisk" \
      --replace "/sbin/partprobe" "${parted}/bin/partprobe" \
      --replace "/usr/sbin" "${partclone}/bin"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    dtkwidget
    qt5integration
    qt5platform-plugins
    libuuid
    parted
    partclone
  ];

  cmakeFlags = [
    "-DDISABLE_DFM_PLUGIN=YES"
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Disk and partition backup/restore tool";
    homepage = "https://github.com/linuxdeepin/deepin-clone";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
    broken = true;
  };
}
