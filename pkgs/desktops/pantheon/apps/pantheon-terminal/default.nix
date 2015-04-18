{ stdenv, fetchurl, perl, cmake, vala, pkgconfig, glib, gtk3, granite, gnome3, libnotify, gettext, makeWrapper }:

stdenv.mkDerivation rec {
  majorVersion = "0.3";
  minorVersion = "0.1";
  name = "pantheon-terminal-${majorVersion}.${minorVersion}";
  src = fetchurl {
    url = "https://launchpad.net/pantheon-terminal/${majorVersion}.x/${majorVersion}.${minorVersion}/+download/${name}.tgz";
    sha256 = "14wspqxp79myyyjngr1x7jg1kw15g3nm2pav2zffp8xs16s1i5za";
  };

  preConfigure = ''
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${granite}/lib64/pkgconfig"
  '';

  preFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
    done
  '';

  buildInputs = [perl cmake vala pkgconfig glib gtk3 granite gnome3.vte gnome3.libgee libnotify gettext makeWrapper];
  meta = {
    description = "elementary OS's terminal";
    longDescription = "A super lightweight, beautiful, and simple terminal. It's designed to be setup with sane defaults and little to no configuration. It's just a terminal, nothing more, nothing less. Designed for elementary OS.";
    homepage = https://launchpad.net/pantheon-terminal;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vozz ];
  };
}
