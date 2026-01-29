{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  curl,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "uacme";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-he0k4o/5JGFDxLrHBO6PNtRgKUzIkGby96cSz0ymuRs=";
  };

  configureFlags = [ "--with-openssl" ];

  nativeBuildInputs = [
    asciidoc
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
  ];

  meta = {
    description = "ACMEv2 client written in plain C with minimal dependencies";
    homepage = "https://github.com/ndilieto/uacme";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ malte-v ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
