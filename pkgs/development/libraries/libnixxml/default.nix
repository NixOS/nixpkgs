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

  postPatch = ''
    # Remove broken test
    substituteInPlace tests/draw/Makefile.am \
      --replace "draw-wrong.sh" ""
    rm tests/draw/draw-wrong.sh
  '';

  preAutoreconf = ''
    # Copied from bootstrap script
    ln -s README.md README
    mkdir -p config
  '';

  configureFlags = [ "--with-gd" "--with-glib" ];
  CFLAGS = "-Wall";

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    getopt
    libxslt
  ];
  buildInputs = [
    libxml2
    gd.dev
    glib
    nix
  ];
  checkInputs = [
    nix
  ];

  doCheck = true;

  meta = with lib; {
    description = "XML-based Nix-friendly data integration library";
    homepage = "https://github.com/svanderburg/libnixxml";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
    platforms = platforms.unix;
  };
}
