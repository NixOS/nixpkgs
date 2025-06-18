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
  version = "2.02.51";

  src = fetchFromGitHub {
    owner = "scandum";
    repo = "tintin";
    rev = version;
    hash = "sha256-QU9Q2VbJ44NHm//LTwDoHQIUV/LnLM94I7GtoCxL3js=";
  };

  buildInputs = [
    zlib
    pcre
    gnutls
  ];

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    description = "Free MUD client for macOS, Linux and Windows";
    homepage = "https://tintin.mudhalla.net/index.php";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abathur ];
    mainProgram = "tt++";
    platforms = platforms.unix;
  };
}
