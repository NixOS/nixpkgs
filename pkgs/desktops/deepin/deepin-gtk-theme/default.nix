{ stdenv, fetchFromGitHub, gtk-engine-murrine, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-gtk-theme";
  version = "17.10.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    sha256 = "02yn76h007hlmrd7syd82f0mz1c79rlkz3gy1w17zxfy0gdvagz3";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin GTK Theme";
    homepage = https://github.com/linuxdeepin/deepin-gtk-theme;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
