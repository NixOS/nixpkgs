{
  lib,
  stdenv,
  bash,
  buildPackages,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  perl,
  gnutls,
  libgcrypt,
  vpnc-scripts,
  opensslSupport ? false,
  openssl, # Distributing this is a GPL violation.
}:

stdenv.mkDerivation {
  pname = "vpnc";
  version = "unstable-2021-11-04";

  src = fetchFromGitHub {
    owner = "streambinder";
    repo = "vpnc";
    rev = "c8bb5371b881f8853f191c495e762f834c9def5d";
    sha256 = "1j1p83nfc2fpwczjcggsby0b44hk97ky0s6vns6md3awlbpgdn57";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ] ++ lib.optional (!opensslSupport) pkg-config;

  buildInputs = [
    libgcrypt
    perl
  ] ++ (if opensslSupport then [ openssl ] else [ gnutls ]);

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc/vpnc"
    "SCRIPT_PATH=${vpnc-scripts}/bin/vpnc-script"
  ] ++ lib.optional opensslSupport "OPENSSL_GPL_VIOLATION=yes";

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postPatch =
    ''
      substituteInPlace src/vpnc-disconnect \
        --replace-fail /bin/sh ${lib.getExe' bash "sh"}
      patchShebangs src/makeman.pl
    ''
    + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      # manpage generation invokes the build vpnc, which must be emulating when cross compiling
      substituteInPlace src/makeman.pl --replace-fail \
        '$vpnc --long-help' \
        '${stdenv.hostPlatform.emulator buildPackages} $vpnc --long-help'
    '';

  enableParallelBuilding = true;
  # Missing install depends:
  #   install: target '...-vpnc-unstable-2021-11-04/share/doc/vpnc': No such file or directory
  #   make: *** [Makefile:149: install-doc] Error 1
  enableParallelInstalling = false;
  strictDeps = true;

  meta = with lib; {
    homepage = "https://davidepucci.it/doc/vpnc/";
    description = "Virtual private network (VPN) client for Cisco's VPN concentrators";
    license = if opensslSupport then licenses.unfree else licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
