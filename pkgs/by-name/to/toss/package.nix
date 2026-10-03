{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "toss";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "toss";
    rev = version;
    hash = "sha256-GXihPNUC+EiOEpgGsRFMy1Fm4iqQId4GrBa2xVEDFBc=";
  };
  preInstall = "export DESTDIR=$out/bin";
  meta =

    src.meta // {
      description = "Dead simple LAN file transfers from the command line";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
}
