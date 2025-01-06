{
  stdenv,
  fetchFromGitHub,
  lib,
  zlib,
  pcre,
  gnutls,
}:

stdenv.mkDerivation rec {
  pname = "tintin";
  version = "2.02.42";

  src = fetchFromGitHub {
    owner = "scandum";
    repo = "tintin";
    rev = version;
    hash = "sha256-8+tYI9+yAIEqByr6kDEEs2hqtIVKwC9bgWssXq24dbg=";
  };

  buildInputs = [
    zlib
    pcre
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
}
