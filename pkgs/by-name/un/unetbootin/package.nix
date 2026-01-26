{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  mtools,
  p7zip,
  qt5,
  syslinux,
  util-linux,
  which,
}:

stdenv.mkDerivation rec {
  pname = "unetbootin";
  version = "702";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-psX15XicPXAsd36BhuvK0G3GQS8hV/hazzO0HByCqV4=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */src/unetbootin)
  '';

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qmake
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  # Lots of nice hard-coded paths...
  postPatch = ''
    substituteInPlace unetbootin.cpp \
      --replace /bin/df             ${coreutils}/bin/df \
      --replace /sbin/blkid         ${util-linux}/sbin/blkid \
      --replace /sbin/fdisk         ${util-linux}/sbin/fdisk \
      --replace /sbin/sfdisk        ${util-linux}/sbin/sfdisk \
      --replace /usr/bin/syslinux   ${syslinux}/bin/syslinux \
      --replace /usr/bin/extlinux   ${syslinux}/sbin/extlinux \
      --replace /usr/share/syslinux ${syslinux}/share/syslinux

    substituteInPlace main.cpp \
      --replace /usr/share/unetbootin $out/share/unetbootin

    substituteInPlace unetbootin.desktop \
      --replace /usr/bin $out/bin
  '';

  preConfigure = ''
    lupdate unetbootin.pro
    lrelease unetbootin.pro
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin                unetbootin
    install -Dm644 -t $out/share/unetbootin   unetbootin_*.qm
    install -Dm644 -t $out/share/applications unetbootin.desktop

    runHook postInstall
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        mtools
        p7zip
        which
      ]
    }"
    "--set QT_X11_NO_MITSHM 1"
  ];

  meta = {
    description = "Tool to create bootable live USB drives from ISO images";
    homepage = "https://unetbootin.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "unetbootin";
  };
}
