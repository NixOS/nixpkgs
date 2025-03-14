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
  version = "1.3";

  src = fetchurl {
    url = "https://people.mpi-inf.mpg.de/~uwe/misc/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1vp053bwv8sr40p3pn4sjaiq570zp7knh99z9ynk30v7ml4cz2i8";
  };

  # remove for version >1.3
  patches = [ ./determinism.patch ];

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

  postBuild = ''
    # convert bdf fonts to psf
    build=$(pwd)
    mkdir {psf,otb}
    cd ${bdf2psf}/share/bdf2psf
    for i in $build/genbdf/*.bdf; do
      name="$(basename $i .bdf)"
      bdf2psf \
        --fb "$i" standard.equivalents \
        ascii.set+useful.set+linux.set 512 \
        "$build/psf/$name.psf"
    done
    cd -

    # convert unicode bdf fonts to otb
    for i in $build/genbdf/*-uni.bdf; do
      name="$(basename $i .bdf)"
      fonttosfnt -v -o "$build/otb/$name.otb" "$i"
    done
  '';

  postInstall = ''
    # install psf fonts
    fontDir="$out/share/consolefonts"
    install -m 644 -D psf/*.psf -t "$fontDir"

    # install otb fonts
    fontDir="$out/share/fonts/X11/misc"
    install -m 644 -D otb/*.otb -t "$fontDir"
    mkfontdir "$fontDir"
  '';

  # Nix with multiple outputs adds several flags
  # that the ./configure script doesn't understand.
  configurePhase = ''
    runHook preConfigure
    ./configure --prefix="$out"
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
