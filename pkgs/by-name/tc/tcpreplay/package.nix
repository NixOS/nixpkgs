{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  tcpdump,
}:

stdenv.mkDerivation rec {
  pname = "tcpreplay";
  version = "4.5.2";

  src = fetchurl {
    url = "https://github.com/appneta/tcpreplay/releases/download/v${version}/tcpreplay-${version}.tar.gz";
    sha256 = "sha256-zP87spRpoEzMIO0LUY4+Q8Sntah2M52UNb/Z23/l0PE=";
  };

  buildInputs = [ libpcap ];

  # Allow having different prefix for header files (default output
  # "out") and libraries ("lib" output)
  postPatch = ''
    substituteInPlace configure \
      --replace-fail 'ls ''${testdir}/$dir/libpcap' 'ls ${lib.getLib libpcap}/$dir/libpcap'
  '';

  configureFlags = [
    "--disable-local-libopts"
    "--disable-libopts-install"
    "--enable-dynamic-link"
    "--enable-shared"
    "--enable-tcpreplay-edit"
    "--with-libpcap=${libpcap}"
    "--with-tcpdump=${tcpdump}/bin/tcpdump"
  ];

  meta = with lib; {
    description = "Suite of utilities for editing and replaying network traffic";
    homepage = "https://tcpreplay.appneta.com/";
    license = with licenses; [
      bsdOriginalUC
      gpl3Only
    ];
    maintainers = with maintainers; [ eleanor ];
    platforms = platforms.unix;
  };
}
