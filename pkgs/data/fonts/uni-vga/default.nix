{ stdenv, fetchurl, perl, kbd, bdftopcf
, libfaketime, fonttosfnt, mkfontscale
}:

with stdenv.lib;

stdenv.mkDerivation {
  name = "uni-vga";

  src = fetchurl {
    url = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/uni-vga.tgz;
    sha256 = "05sns8h5yspa7xkl81ri7y1yxf5icgsnl497f3xnaryhx11s2rv6";
  };

  nativeBuildInputs =
    [ bdftopcf libfaketime
      fonttosfnt mkfontscale
    ] ++ optionals stdenv.isLinux [ perl kbd ];

  postPatch = "patchShebangs .";

  buildPhase = ''
    # convert font to compressed pcf
    bdftopcf u_vga16.bdf | gzip -c -9 -n  > u_vga16.pcf.gz

    # convert bdf font to otb
    faketime -f "1970-01-01 00:00:01" \
    fonttosfnt -v -o u_vga16.otb u_vga16.bdf
  '' + optionalString stdenv.isLinux ''
    # convert font to compressed psf
    ./bdf2psf.pl -s UniCyrX.sfm u_vga16.bdf \
      | psfaddtable - UniCyrX.sfm - \
      | gzip -c -9 -n > u_vga16.psf.gz
  '';

  installPhase = ''
    # install pcf (for X11 applications)
    install -m 644 -D *.pcf.gz -t "$out/share/fonts"
    mkfontdir "$out/share/fonts"

    # install bdf font
    install -m 644 -D *.bdf -t "$bdf/share/fonts"
    mkfontdir "$bdf/share/fonts"

    # install otb font (for GTK applications)
    install -m 644 -D *.otb -t "$otb/share/fonts"
    mkfontdir "$otb/share/fonts"
  '' + optionalString stdenv.isLinux ''
    # install psf (for linux virtual terminal)
    install -m 644 -D *.psf.gz -t "$out/share/consolefonts"
  '';

  outputs = [ "out" "bdf" "otb" ];

  meta = {
    description = "Unicode VGA font";
    maintainers = [ maintainers.ftrvxmtrx ];
    homepage = http://www.inp.nsk.su/~bolkhov/files/fonts/univga/;
    license = licenses.mit;
  };
}
