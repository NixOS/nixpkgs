{ stdenv, fetchFromGitHub, gtk-engine-murrine, deepin }:

stdenv.mkDerivation rec {
  pname = "deepin-gtk-theme";
  version = "17.10.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    sha256 = "0zs6mq70yd1k3d9zm3q6zxnw1md56r4imad5imdxwx58yxdx47fw";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  makeFlags = [ "PREFIX=${placeholder ''out''}" ];

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin GTK Theme";
    homepage = https://github.com/linuxdeepin/deepin-gtk-theme;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
