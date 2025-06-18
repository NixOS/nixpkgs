{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "whsniff";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "homewsn";
    repo = "whsniff";
    rev = "v${version}";
    sha256 = "000l5vk9c0332m35lndk8892ivdr445lgg25hmq1lajn24cash5w";
  };

  buildInputs = [ libusb1 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/homewsn/whsniff";
    description = "Packet sniffer for 802.15.4 wireless networks";
    mainProgram = "whsniff";
    maintainers = with maintainers; [ snicket2100 ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
