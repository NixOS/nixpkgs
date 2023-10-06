{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, dde-polkit-agent
, libsecret
, libgnome-keyring
}:

stdenv.mkDerivation rec {
  pname = "dpa-ext-gnomekeyring";
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-mXaGwbtEwaqfOT0izK64zX4s3VFmsRpUGOVm6oSEhn8=";
  };

  postPatch = ''
    substituteInPlace gnomekeyringextention.cpp \
      --replace "/usr/share/dpa-ext-gnomekeyring" "$out/share/dpa-ext-gnomekeyring"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dde-polkit-agent
    libgnome-keyring
    libsecret
  ];

  meta = with lib; {
    description = "GNOME keyring extension for dde-polkit-agent";
    homepage = "https://github.com/linuxdeepin/dpa-ext-gnomekeyring";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
