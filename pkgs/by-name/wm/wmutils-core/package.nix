{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libxcb-util,
  libxcb-cursor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmutils-core";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "core";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OKAvJovGu9rMxEe5g4kdL7Foj41kl3zUYIJa04jf0dI=";
  };

  buildInputs = [
    libxcb
    libxcb-util
    libxcb-cursor
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Set of window manipulation tools";
    homepage = "https://github.com/wmutils/core";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
