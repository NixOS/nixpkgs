{ stdenv
, fetchFromGitHub
, gtk-engine-murrine
, deepin
}:

stdenv.mkDerivation rec {
  pname = "deepin-gtk-theme";
  version = "2020.06.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    sha256 = "1ah99nj7dws4mq3i6hkv2sk84098zh33lp4g9y9phbfpgm1q1qvi";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin GTK Theme";
    homepage = "https://github.com/linuxdeepin/deepin-gtk-theme";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
