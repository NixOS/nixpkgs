{
  stdenv,
  fetchFromGitHub,
  lib,
  zlib,
  pcre2,
  gnutls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tintin";
  version = "2.02.60";

  src = fetchFromGitHub {
    owner = "scandum";
    repo = "tintin";
    rev = finalAttrs.version;
    hash = "sha256-2pkQv3Tf0cT0P7x1eiQYYlDYr9kA5F4DQxb8muJFX6Y=";
  };

  buildInputs = [
    zlib
    pcre2
    gnutls
  ];

  preConfigure = ''
    cd src
  '';

  meta = {
    description = "Free MUD client for macOS, Linux and Windows";
    homepage = "https://tintin.mudhalla.net/index.php";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ abathur ];
    mainProgram = "tt++";
    platforms = lib.platforms.unix;
  };
})
