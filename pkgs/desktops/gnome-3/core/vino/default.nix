{ stdenv, intltool, fetchurl, gtk3, glib, libsoup, pkgconfig, makeWrapper
, libnotify, file }:

stdenv.mkDerivation rec {
  name = "vino-${versionMajor}.${versionMinor}";
  versionMajor = "3.10";
  versionMinor = "1";

  src = fetchurl {
    url = "mirror://gnome/sources/vino/${versionMajor}/${name}.tar.xz";
    sha256 = "0imyvz96b7kikikwxn1r5sfxwmi40523nd66gp9hrl23gik0vwgs";
  };

  doCheck = true;

  buildInputs = [ gtk3 intltool glib libsoup pkgconfig libnotify file makeWrapper ];

  postInstall = ''
    for f in "$out/bin/vino-passwd" "$out/libexec/vino-server"; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${gtk3}/share:$out/share"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
