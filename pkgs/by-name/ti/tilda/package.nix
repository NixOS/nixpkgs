{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, expat
, gettext
, gtk3
, libconfuse
, makeWrapper
, pcre2
, pkg-config
, vte
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilda";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "lanoxx";
    repo = "tilda";
    rev = "tilda-${finalAttrs.version}";
    hash = "sha256-uDx28jmjNUyzJbgTJiHbjI9U5mYb9bnfl/9AjbxNUWA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gettext
    gtk3
    libconfuse
    pcre2
    vte
  ];

  # ugly hack for xgettext to work during build
  env.LD_LIBRARY_PATH = "${lib.getLib expat}/lib";

  # The config locking scheme relies on the binary being called "tilda"
  # (`pgrep -C tilda`), so a simple `wrapProgram` won't suffice:
  postInstall = ''
    mkdir $out/bin/wrapped
    mv "$out/bin/tilda" "$out/bin/wrapped/tilda"
    makeWrapper "$out/bin/wrapped/tilda" "$out/bin/tilda" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  passthru.tests.test = nixosTests.terminal-emulators.tilda;

  meta = {
    homepage = "https://github.com/lanoxx/tilda/";
    description = "A Gtk based drop down terminal for Linux and Unix";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
