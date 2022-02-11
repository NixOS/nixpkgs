{ lib, stdenv, autoconf, automake, libtool, m4, fetchurl, bash, pkg-config, sqlite }:

stdenv.mkDerivation rec {
  pname = "libcangjie";
  version = "1.4_rev_${rev}";
  rev = "a73c1d8783f7b6526fd9b2cc44a669ffa5518d3d";

  # fetchFromGitLab isn't working for some reason
  src = fetchurl {
    url = "https://gitlab.freedesktop.org/cangjie/libcangjie/-/archive/a73c1d8783f7b6526fd9b2cc44a669ffa5518d3d/libcangjie-a73c1d8783f7b6526fd9b2cc44a669ffa5518d3d.tar.gz";
    sha256 = "sha256-j5IQ0hBefoF8p966YrfZgYCw7ht5twJhYi4l0NneukQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ automake autoconf libtool m4 sqlite ];

  configureScript = "./autogen.sh";

  preConfigure = ''
    find . -name '*.sh' -exec sed -e 's@#!/bin/bash@${bash}/bin/bash@' -i '{}' ';'
  '';

  doCheck = true;

  meta = {
    description = "A C library implementing the Cangjie input method";
    longDescription = ''
      libcangjie is a library implementing the Cangjie input method.
    '';
    homepage = "https://gitlab.freedesktop.org/cangjie/libcangjie";
    license = lib.licenses.lgpl3Plus;

    maintainers = [ lib.maintainers.linquize ];
    platforms = lib.platforms.all;
  };
}
