{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libpcap,
  wolfssl,
}:

stdenv.mkDerivation rec {
  pname = "vde2";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "virtualsquare";
    repo = "vde-2";
    rev = "v${version}";
    sha256 = "sha256-Yf6QB7j5lYld2XtqhYspK4037lTtimoFc7nCavCP+mU=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/vde2/musl-build-fix.patch?id=ddee2f86a48e087867d4a2c12849b2e3baccc238";
      sha256 = "0b5382v541bkxhqylilcy34bh83ag96g71f39m070jzvi84kx8af";
    })
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libpcap
    wolfssl
  ];

  meta = with lib; {
    homepage = "https://github.com/virtualsquare/vde-2";
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
