{
  lib,
  stdenv,
  fetchurl,
  perl,
  bdftopcf,
  bdf2psf,
  xorg,
  targetsDat ? null,
  variantsDat ? null,
}:

stdenv.mkDerivation rec {
  pname = "uw-ttyp0";
  version = "2.1";

  src = fetchurl {
    url = "https://people.mpi-inf.mpg.de/~uwe/misc/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-mVBt2HlOGl1c1YEebB5V7u+Yn4w1Af25Jlvalyq6FjA=";
  };

  nativeBuildInputs = [
    perl
    bdftopcf
    bdf2psf
    xorg.fonttosfnt
    xorg.mkfontdir
  ];

  # configure sizes, encodings and variants
  preConfigure =
    (
      if targetsDat == null then
        ''
          cat << EOF > TARGETS.dat
          SIZES = 11 12 13 14 15 16 17 18 22 \
          11b 12b 13b 14b 15b 16b 17b 18b 22b 15i 16i 17i 18i
          ENCODINGS = uni
          GEN_PCF = 1
          GEN_OTB = 1
          GEN_CONS_LINUX = 1
          EOF
        ''
      else
        ''cp "${targetsDat}" TARGETS.dat''
    )
    + (
      if variantsDat == null then
        ''
          cat << EOF > VARIANTS.dat
          COPYTO AccStress PApostropheAscii
          COPYTO PAmComma AccGraveAscii
          COPYTO Digit0Slashed Digit0
          EOF
        ''
      else
        ''cp "${variantsDat}" VARIANTS.dat''
    );

  configurePhase = ''
    runHook preConfigure
    ./configure \
      --prefix="$out" \
      --otbdir="$out/share/fonts/X11/misc" \
      --pcfdir="$out/share/fonts/X11/misc" \
      --conslinuxdir="$out/share/consolefonts"
    runHook postConfigure
  '';

  meta = with lib; {
    description = "Monospace bitmap screen fonts for X11";
    homepage = "https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/";
    license = with licenses; [
      free
      mit
    ];
    maintainers = with maintainers; [ rnhmjoj ];
  };

}
