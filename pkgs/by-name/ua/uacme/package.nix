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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TiijVeY7MXNaFE+ZYg8G6yYjafTwRA+y6zlwUNnPR48=";
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
