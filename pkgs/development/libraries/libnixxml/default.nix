{ fetchFromGitHub, stdenv, autoreconfHook, pkg-config, libxml2, gd, glib, getopt, libxslt, nix }:

stdenv.mkDerivation {
  name = "libnixxml";
  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libnixxml";
    rev = "54c04a5fdbc8661b2445a7527f499e0a77753a1a";
    sha256 = "sha256-HKQnCkO1TDs1e0MDil0Roq4YRembqRHQvb7lK3GAftQ=";
  };
  configureFlags = [ "--with-gd" "--with-glib" ];
  CFLAGS = "-Wall";
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pkg-config libxml2 gd.dev glib getopt libxslt nix ];
  doCheck = false;
  postPatch = ''
    ./bootstrap
  '';

  meta = with stdenv.lib; {
    description = "XML-based Nix-friendly data integration library";
    homepage = https://github.com/svanderburg/libnixxml;
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
    platforms = platforms.unix;
  };
}
