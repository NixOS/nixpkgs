{ stdenv, fetchFromGitHub, cmake, qt5, lxqt, hicolor_icon_theme, xmessage }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-common";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "07ih2w9ksbxqwy36xvgb9b31740nhkm7ap70wvv8q6x0wyhn71gn";
  };

  nativeBuildInputs = [
    cmake
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtsvg
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
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
