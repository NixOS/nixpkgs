{
  lib,
  stdenv,
  fetchurl,
  python3,
  bdftopcf,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminus-font";
  version = "4.49.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/terminus-font/terminus-font-${lib.versions.majorMinor finalAttrs.version}/terminus-font-${finalAttrs.version}.tar.gz";
    hash = "sha256-2WHBt4Fie/QX+bNAaT1k/CGeAROtOjrxo0JMeqNz73k=";
  };

  patches = [ ./SOURCE_DATE_EPOCH-for-otb.patch ];

  nativeBuildInputs = [
    python3
    bdftopcf
    xorg.mkfontscale
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
    substituteInPlace Makefile --replace 'gzip'     'gzip -n'
  '';

  installTargets = [
    "install"
    "install-otb"
    "fontdir"
  ];
  # fontdir depends on the previous two targets, but this is not known
  # to make, so we need to disable parallelism:
  enableParallelInstalling = false;

  meta = {
    description = "Clean fixed width font";
    longDescription = ''
      Terminus Font is designed for long (8 and more hours per day) work
      with computers. Version 4.30 contains 850 characters, covers about
      120 language sets and supports ISO8859-1/2/5/7/9/13/15/16,
      Paratype-PT154/PT254, KOI8-R/U/E/F, Esperanto, many IBM, Windows and
      Macintosh code pages, as well as the IBM VGA, vt100 and xterm
      pseudographic characters.

      The sizes present are 6x12, 8x14, 8x16, 10x20, 11x22, 12x24, 14x28 and
      16x32. The styles are normal and bold (except for 6x12), plus
      EGA/VGA-bold for 8x14 and 8x16.
    '';
    homepage = "https://terminus-font.sourceforge.net/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ azey7f ];
  };
})
