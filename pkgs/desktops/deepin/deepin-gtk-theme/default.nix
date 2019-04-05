{ stdenv, fetchFromGitHub, gtk-engine-murrine, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-gtk-theme";
  version = "17.10.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    sha256 = "0vwly24cvjwhvda7g3l595vpf99d2z7b2zr0q5kna4df4iql7vn4";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  makeFlags = [ "PREFIX=${placeholder ''out''}" ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin GTK Theme";
    homepage = https://github.com/linuxdeepin/deepin-gtk-theme;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
