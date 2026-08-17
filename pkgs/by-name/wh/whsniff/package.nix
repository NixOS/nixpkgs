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
    sha256 = "000l5vk9c0332m35lndk8892ivdr445lgg25hmq1lajn24cash5w";
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
