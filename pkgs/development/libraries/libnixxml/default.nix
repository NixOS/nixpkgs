{ fetchFromGitHub, lib, stdenv, autoreconfHook, pkg-config, libxml2, gd, glib, getopt, libxslt, nix }:

stdenv.mkDerivation {
  pname = "libnixxml";
  version = "unstable-2020-06-25";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libnixxml";
    rev = "54c04a5fdbc8661b2445a7527f499e0a77753a1a";
    sha256 = "sha256-HKQnCkO1TDs1e0MDil0Roq4YRembqRHQvb7lK3GAftQ=";
  };

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [ "--with-gd" "--with-glib" ];
  CFLAGS = "-Wall";

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libxml2 gd.dev glib getopt libxslt nix ];

  doCheck = false;

  meta = with lib; {
    description = "XML-based Nix-friendly data integration library";
    homepage = "https://github.com/svanderburg/libnixxml";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
    platforms = platforms.unix;
  };
}
