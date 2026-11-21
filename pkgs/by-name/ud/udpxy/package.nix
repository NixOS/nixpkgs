{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udpxy";
  version = "1.0-25.2";

  src = fetchFromGitHub {
    owner = "pcherenkov";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-v+w4Y6MyJqUrgwuYUYTZW0Zn1jhW4vEpgBEQyEjvkzg=";
  };

  sourceRoot = "${finalAttrs.src.name}/chipmunk";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ gzip ];
  nativeInstallCheckInputs = [ versionCheckHook ];

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

  # Upstream does not ship a test suite.
  doCheck = false;

  doInstallCheck = true;
  # udpxy does not implement --version/--help. Any accepted option without
  # a -p port makes it print the usage banner, which starts with
  # "udpxy <version>".
  versionCheckProgramArg = "-v";

  meta = with lib; {
    description = "Lightweight UDP-to-HTTP multicast traffic relay daemon";
    homepage = "https://github.com/pcherenkov/udpxy";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "udpxy";
    maintainers = with maintainers; [ bachp ];
  };
})
