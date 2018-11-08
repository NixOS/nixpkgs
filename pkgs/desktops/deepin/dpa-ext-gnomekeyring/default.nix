{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, gnome3, dde-polkit-agent }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dpa-ext-gnomekeyring";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "168j42nwyw7vcgwc0fha2pjpwwlgir70fq1hns4ia1dkdqa1nhzw";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
  ];

  buildInputs = [
    dde-polkit-agent
    gnome3.libgnome-keyring
  ];

  postPatch = ''
    patchShebangs .

    sed -i dpa-ext-gnomekeyring.pro gnomekeyringextention.cpp \
      -e "s,/usr,$out,"
  '';

  meta = with stdenv.lib; {
    description = "GNOME keyring extension for dde-polkit-agent";
    homepage = https://github.com/linuxdeepin/dpa-ext-gnomekeyring;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
