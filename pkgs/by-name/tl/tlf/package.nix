{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  autoconf,
  automake,
  pkg-config,
  glib,
  perl,
  python3Packages,
  ncurses5,
  hamlib,
  xmlrpc_c,
  pythonPluginSupport ? true,
  python3,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlf";
  version = "1.4.1-unstable-2026-03-27";

  src = fetchFromGitHub {
    owner = "Tlf";
    repo = "tlf";
    rev = "e6385f88ad793043d874b89d56d29bea5dac4e26";
    hash = "sha256-XYj0vUqxnc6SuH+fV0EWgVBV3W1W2yhMCK/zcEWrMQ4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
    pkg-config
    perl
    python3Packages.pexpect
  ];

  buildInputs = [
    glib
    ncurses5
    hamlib
    xmlrpc_c
  ]
  ++ lib.optionals pythonPluginSupport [
    python3
  ];

  configureFlags = [
    "--enable-fldigi-xmlrpc"
  ]
  ++ lib.optionals pythonPluginSupport [
    "--enable-python-plugin"
  ];

  nativeCheckInputs = [
    cmocka
  ];

  doCheck = true;

  postInstall = ''
    mkdir -p $out/lib
    ln -s ${ncurses5.out}/lib/libtinfo.so.5 $out/lib/libtinfo.so.5
  '';

  meta = {
    description = "Advanced ham radio logging and contest program";
    longDescription = ''
      TLF is a curses based console mode general logging and contest program for
      amateur radio.

      It supports the CQWW, the WPX, the ARRL-DX, the ARRL-FD, the PACC and the
      EU SPRINT shortwave contests (single operator) as well as a LOT MORE basic
      contests, general QSO and DXpedition mode.
    '';
    homepage = "https://tlf.github.io/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
