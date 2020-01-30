{ stdenv, fetchFromGitHub, meson, sassc, pkg-config, glib, ninja,
  python3, gtk3, gnome3, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "yaru";
  version = "19.10.5";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = version;
    sha256 = "0d53flfkb01kycchdhv72ga0qh8947bxvm5njfrrbk6rqfg0zc1v";
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
