{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  basename = "pidgin-im-gnome-shell-extension";
  name = "${basename}-${version}";

  src = fetchFromGitHub {
    owner = "muffinmad";
    repo = "${basename}";
    rev = "v${version}";
    sha256 = "1567s2sfqig4jw0nrn134f5vkx0yq31q044grv3xk4vpl1f3z2lr";
  };

  buildInputs = [ glib ];

  configurePhase = "";
  buildPhase = "";
  installPhase = ''
    share_dir="$prefix/share"
    extensions_dir="$share_dir/gnome-shell/extensions/pidgin@muffinmad"
    mkdir -p "$extensions_dir"
    mv *.js metadata.json dbus.xml gnome-shell-extension-pidgin.pot "$extensions_dir"

    schemas_dir="$share_dir/gsettings-schemas/${name}/glib-2.0/schemas"
    mkdir -p "$schemas_dir"
    mv schemas/* "$schemas_dir" # fix Emacs syntax highlighting: */
    ${glib.dev}/bin/glib-compile-schemas "$schemas_dir"

    locale_dir="$share_dir/locale"
    mkdir -p "$locale_dir"
    mv locale/* $locale_dir # fix Emacs syntax highlighting: */
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/muffinmad/pidgin-im-gnome-shell-extension;
    description = "Make Pidgin IM conversations appear in the Gnome Shell message tray";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ DamienCassou ];
  };
}
