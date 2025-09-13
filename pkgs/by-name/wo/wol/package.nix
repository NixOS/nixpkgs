{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "wol";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/wake-on-lan/${pname}-${version}.tar.gz";
    sha256 = "08i6l5lr14mh4n3qbmx6kyx7vjqvzdnh3j9yfvgjppqik2dnq270";
  };

  patches = [
    ./gcc-14.patch
    ./macos-10_7-getline.patch
  ];

  nativeBuildInputs = [
    perl # for pod2man in order to get a manpage
    autoreconfHook # for the patch
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Implements Wake On LAN functionality in a small program";
    homepage = "https://sourceforge.net/projects/wake-on-lan/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "wol";
    platforms = platforms.unix;
  };
}
