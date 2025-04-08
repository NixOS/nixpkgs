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
stdenv.mkDerivation rec {
  pname = "uacme";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "ndilieto";
    repo = "uacme";
    rev = "v${version}";
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

  meta = with lib; {
    description = "ACMEv2 client written in plain C with minimal dependencies";
    homepage = "https://github.com/ndilieto/uacme";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ malte-v ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
