{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, xorg, hicolor_icon_theme, xmessage }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-common";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "14nx3zcknwsn713wdnmb2xl15vf21vh13kxscdwmfnd48m5j4m3b";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    hicolor_icon_theme
    xmessage
  ];

  postPatch = lxqt.standardPatch
  + ''
    substituteInPlace ./startlxqt.in \
      --replace  "cp " "cp --no-preserve=mode " \
      --replace xmessage "${xmessage}"/bin/xmessage
  '';

  meta = with stdenv.lib; {
    description = "Common files for LXQt";
    homepage = https://github.com/lxde/lxqt-common;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
