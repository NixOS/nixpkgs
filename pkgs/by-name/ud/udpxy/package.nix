{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udpxy";
  version = "1.0-25.2";

  src = fetchFromGitHub {
    owner = "pcherenkov";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-v+w4Y6MyJqUrgwuYUYTZW0Zn1jhW4vEpgBEQyEjvkzg=";
  };

  sourceRoot = "${finalAttrs.src.name}/chipmunk";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ gzip ];

  # The project uses -Werror which causes build failures with newer GCC versions
  # due to warnings about strncpy truncation and other modern warning checks
  postPatch = ''
    substituteInPlace Makefile --replace "-Werror" ""
  '';

  installFlags = [
    "PREFIX=$(out)"
    "GZIP=${gzip}/bin/gzip"
    "MANPAGE_DIR=$(out)/share/man/man1"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Lightweight UDP-to-HTTP multicast traffic relay daemon";
    homepage = "https://github.com/pcherenkov/udpxy";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = finalAttrs.pname;
    maintainers = with maintainers; [ bachp ];
  };
})
