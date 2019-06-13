{ stdenv, lib, fetchFromGitHub, glib, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-tilingnome";
  version = "unstable-2019-01-18";

  src = fetchFromGitHub {
    owner = "rliang";
    repo = pname;
    rev = "bd4fb8c19f7a6282b38724b30e62645143390226";
    sha256 = "1y4s4n88gdkpvgd3v3dg0181ccyhlixbvkx3bwyvdxyyyxbqibid";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    glib-compile-schemas .
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}/
  '';

  uuid = "tilingnome@rliang.github.com";

  meta = with stdenv.lib; {
    description = "Tiling window management for GNOME Shell";
    license = licenses.gpl2;
    maintainers = with maintainers; [ benley ];
    homepage = https://github.com/rliang/gnome-shell-extension-tilingnome;
    platforms = gnome3.gnome-shell.meta.platforms;
    broken = lib.versionAtLeast gnome3.gnome-shell.version "3.31";
  };
}
