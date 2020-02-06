{ stdenv, fetchurl, perl
, bdftopcf, bdf2psf, mkfontdir
, fonttosfnt
, targetsDat  ? null
, variantsDat ? null
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

  nativeBuildInputs = [ perl bdftopcf bdf2psf fonttosfnt mkfontdir ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash     = "0hzhaakbbcnz5ksi5p8mavw9578rsqlqadkrirrkhfnyqqlrii4j";

  # configure sizes, encodings and variants
  preConfigure =
    (if targetsDat == null
      then ''
        cat << EOF > TARGETS.dat
        SIZES = 11 12 13 14 15 16 17 18 22 \
        11b 12b 13b 14b 15b 16b 17b 18b 22b 15i 16i 17i 18i
        ENCODINGS = uni
        EOF
      ''
      else ''cp "${targetsDat}" TARGETS.dat'') +
    (if variantsDat == null
      then ''
        cat << EOF > VARIANTS.dat
        COPYTO AccStress PApostropheAscii
        COPYTO PAmComma AccGraveAscii
        COPYTO Digit0Slashed Digit0
        EOF
      ''
      else ''cp "${variantsDat}" VARIANTS.dat'');

  postBuild = ''
    # convert bdf to psf and otb fonts
    build=$(pwd)
    mkdir {psf,otb}
    cd ${bdf2psf}/share/bdf2psf
    for i in $build/genbdf/*.bdf; do
      name="$(basename $i .bdf)"
      bdf2psf \
        --fb "$i" standard.equivalents \
        ascii.set+useful.set+linux.set 512 \
        "$build/psf/$name.psf"
      fonttosfnt -v -o "$build/otb/$name.otb" "$i"
    done
    cd $build
  '';

  postInstall = ''
    # install psf fonts
    fontDir="$out/share/consolefonts"
    mkdir -p "$fontDir"
    mv -t "$fontDir" psf/*.psf
    mv -t "$out/share/fonts/X11/misc" otb/*.otb
  '';

  meta = with stdenv.lib; {
    description = "Monospace bitmap screen fonts for X11";
    homepage = https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/;
    license = with licenses; [ free mit ];
    maintainers = with maintainers; [ rnhmjoj ];
  };

}
