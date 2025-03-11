{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  linux-pam,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "tcb";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = pname;
    rev = "070cf4aa784de13c52788ac22ff611d7cbca0854";
    sha256 = "sha256-Sp5u7iTEZZnAqKQXoPO8eWpSkZeBzQqZI82wRQmgU9A=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    linux-pam
    libxcrypt
  ];

  patches = [ ./fix-makefiles.patch ];

  postPatch = ''
    substituteInPlace Make.defs \
      --replace "PREFIX = /usr" "PREFIX = $out" \
      --replace "SBINDIR = /sbin" "SBINDIR = $bin/bin" \
      --replace "INCLUDEDIR = \$(PREFIX)/include" "INCLUDEDIR = $dev/include"

    # Override default 'CC=gcc'
    makeFlagsArray+=("CC=$CC")
  '';

  meta = with lib; {
    description = "Alternative password shadowing scheme";
    longDescription = ''
      The tcb package contains core components of our tcb suite implementing the alternative
      password shadowing scheme on Openwall GNU Linux (Owl). It is being made available
      separately from Owl primarily for use by other distributions.

      The package consists of three components: pam_tcb, libnss_tcb, and libtcb.

      pam_tcb is a PAM module which supersedes pam_unix. It also implements the tcb password
      shadowing scheme. The tcb scheme allows many core system utilities (passwd(1) being
      the primary example) to operate with little privilege. libnss_tcb is the accompanying
      NSS module. libtcb contains code shared by the PAM and NSS modules and is also used
      by user management tools on Owl due to our shadow suite patches.
    '';
    homepage = "https://www.openwall.com/tcb/";
    license = licenses.bsd3;
    platforms = systems.inspect.patterns.isGnu;
    maintainers = with maintainers; [ izorkin ];
  };
}
