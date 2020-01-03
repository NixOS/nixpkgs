{ stdenv, fetchFromGitHub, meson, sassc, pkg-config, glib, ninja,
  python3, gtk3, gnome3, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "yaru";
  version = "19.10.4";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = version;
    sha256 = "1dj6awlz13787783ds9mdid75rd4vvgpg52h6x19pxdga3k17s9b";
  };

  nativeBuildInputs = [ meson sassc pkg-config glib ninja python3 ];
  buildInputs = [ gtk3 gnome3.gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = "patchShebangs .";

  meta = with stdenv.lib; {
    description = "Ubuntu community theme 'yaru' - default Ubuntu theme since 18.10";
    homepage = https://github.com/ubuntu/yaru;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.jD91mZM2 ];
  };
}
