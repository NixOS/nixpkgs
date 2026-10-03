{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whsniff";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "homewsn";
    repo = "whsniff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vECtGBFWKhpwhUW8Rwshue0oEkKzWVpGFWMAluYuFAA=";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/homewsn/whsniff";
    description = "Packet sniffer for 802.15.4 wireless networks";
    mainProgram = "whsniff";
    maintainers = with lib.maintainers; [ snicket2100 ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
})
