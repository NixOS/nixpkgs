{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  qt5,
  libsForQt5,
  docbook-xsl-nons,
}:

stdenv.mkDerivation rec {
  pname = "vmpk";
  version = "0.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-+NjTcszb1KXGynIcCf4IEDvN4f8pgXtR1TksxGR5ZHQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.qttools
    docbook-xsl-nons
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.drumstick
    qt5.qtx11extras
  ];

  postInstall = ''
    # vmpk drumstickLocales looks here:
    ln -s ${libsForQt5.drumstick}/share/drumstick $out/share/
  '';

  meta = with lib; {
    description = "Virtual MIDI Piano Keyboard";
    mainProgram = "vmpk";
    homepage = "http://vmpk.sourceforge.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
