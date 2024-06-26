{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libbsd,
  openssl,
  libmilter,
  autoreconfHook,
  perl,
  makeWrapper,
  unbound,
}:

stdenv.mkDerivation rec {
  pname = "opendkim";
  version = "2.11.0-Beta2";

  src = fetchFromGitHub {
    owner = "trusteddomainproject";
    repo = "OpenDKIM";
    rev = "rel-opendkim-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "0nx3in8sa6xna4vfacj8g60hfzk61jpj2ldag80xzxip9c3rd2pw";
  };

  configureFlags = [
    "--with-milter=${libmilter}"
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ] ++ lib.optional stdenv.isDarwin "--with-unbound=${unbound}";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libbsd
    openssl
    libmilter
    perl
  ] ++ lib.optional stdenv.isDarwin unbound;

  postInstall = ''
    wrapProgram $out/sbin/opendkim-genkey \
      --prefix PATH : ${openssl.bin}/bin
  '';

  meta = with lib; {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = "http://www.opendkim.org/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
