{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, cmake
, libtirpc, rpcsvc-proto, avahi, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblxi";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "liblxi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jS0huNkbyKrsJ3NkenrYtjkzLakOsTJpwlgSo98ribE=";
  };

  postPatch = ''
    # needed by darwin
    sed -e 1i'#include <string.h>' \
        -e 1i'#include <stdlib.h>' \
        -i src/bonjour.c
  '';

  nativeBuildInputs = [ meson ninja cmake pkg-config rpcsvc-proto ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libtirpc
    avahi
  ] ++ [
    libxml2
  ];

  meta = with lib; {
    description = "Library for communicating with LXI compatible instruments";
    longDescription = ''
      liblxi is an open source software library which offers a simple
      API for communicating with LXI compatible instruments.
      The API allows applications to easily discover instruments
      on networks and communicate SCPI commands.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.vq ];
  };
})
