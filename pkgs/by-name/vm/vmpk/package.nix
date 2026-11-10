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

stdenv.mkDerivation (finalAttrs: {
  pname = "vmpk";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/vmpk/${finalAttrs.version}/vmpk-${finalAttrs.version}.tar.bz2";
    hash = "sha256-5T17gsIyw5SSjPzhnkRzsrnTqLQblKQoY77VWqGRVNs=";
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

  meta = {
    description = "Virtual MIDI Piano Keyboard";
    mainProgram = "vmpk";
    homepage = "http://vmpk.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
