{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toss";
  version = "1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "toss";
    tag = finalAttrs.version;
    hash = "sha256-GXihPNUC+EiOEpgGsRFMy1Fm4iqQId4GrBa2xVEDFBc=";
  };

  installFlags = [ "DESTDIR=$(out)/bin" ];

  meta = {
    description = "Dead simple LAN file transfers from the command line";
    homepage = "https://github.com/zerotier/toss";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "toss";
  };
})
