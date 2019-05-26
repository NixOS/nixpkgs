{ stdenv, fetchFromGitHub, fetchpatch, pantheon, pkgconfig, meson, ninja, vala, glib
, gtk3, libgee, desktop-file-utils, geoclue2, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-geoclue2";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0fww65dnbg9zn0gy1q2db39kjra50ykzw05pmn9iwxkijyxi8hm5";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
   ];

  buildInputs = [
    geoclue2
    gtk3
    libgee
   ];

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/pantheon-agent-geoclue2/pull/21
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Pantheon Geoclue2 Agent";
    homepage = https://github.com/elementary/pantheon-agent-geoclue2;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
