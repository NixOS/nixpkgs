{
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  libxml2,
  gd,
  glib,
  getopt,
  libxslt,
  nix,
  bash,
}:

stdenv.mkDerivation {
  pname = "libnixxml";
  version = "unstable-2020-06-25";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "libnixxml";
    rev = "54c04a5fdbc8661b2445a7527f499e0a77753a1a";
    sha256 = "sha256-HKQnCkO1TDs1e0MDil0Roq4YRembqRHQvb7lK3GAftQ=";
  };

  prePatch = ''
    # Remove broken test
    substituteInPlace tests/draw/Makefile.am \
      --replace "draw-wrong.sh" ""
    rm tests/draw/draw-wrong.sh

    # Fix bash path
    substituteInPlace scripts/nixexpr2xml.in \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  preAutoreconf = ''
    # Copied from bootstrap script
    ln -s README.md README
    mkdir -p config
  '';

  configureFlags = [
    "--with-gd"
    "--with-glib"
  ];
  CFLAGS = "-Wall";

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    getopt
    libxslt
  ];
  buildInputs = [
    bash
    libxml2
    gd.dev
    glib
    nix
  ];
  nativeCheckInputs = [
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
