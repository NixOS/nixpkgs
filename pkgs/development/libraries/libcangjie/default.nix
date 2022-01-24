{ lib, stdenv, autoconf, automake, libtool, m4, fetchFromGitLab, bash, pkg-config, sqlite }:

stdenv.mkDerivation rec {
  pname = "libcangjie";
  version = "1.4_rev_${rev}";
  rev = "a73c1d8783f7b6526fd9b2cc44a669ffa5518d3d";

  src = fetchFromGitLab {
    owner = "Cangjians";
    repo = "libcangjie";
    inherit rev;
    sha256 = "sha256-R7WqhxciaTxhTiwPp2EUNTOh477gi/Pj3VpMtat5qXw=";
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
