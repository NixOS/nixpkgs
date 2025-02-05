{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  qt6Packages,
  docbook-xsl-nons,
}:

stdenv.mkDerivation rec {
  pname = "vmpk";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-O/uIg1Wq6Hwt7J5AkoXQshBhrKrQdfVTbb8qr7ttSNw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    docbook-xsl-nons
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.drumstick
  ];

  postInstall = ''
    # vmpk drumstickLocales looks here:
    ln -s ${qt6Packages.drumstick}/share/drumstick $out/share/
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
