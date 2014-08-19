{ stdenv, fetchurl, gnat, zlib }:

assert stdenv.system == "i686-linux";

let
  version = "0.31";
in
stdenv.mkDerivation rec {
  name = "ghdl-mcode-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ghdl/ghdl-${version}.tar.gz";
    sha256 = "1v0l9h6906b0bvnwfi2qg5nz9vjg80isc5qgjxr1yqxpkfm2xcf0";
  };

  buildInputs = [ gnat zlib ];

  # Tarbomb
  preUnpack = ''
    mkdir ghdl
    cd ghdl
  '';

  sourceRoot = "translate/ghdldrv";

  patchPhase = ''
    sed -i 's,$$curdir/lib,'$out'/share/ghdl_mcode/translate/lib,' Makefile
  '';

  postBuild = ''
    # Build the LIB
    ln -s ghdl_mcode ghdl
    make install.mcode
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ghdl_mcode $out/bin

    mkdir -p $out/share/ghdl_mcode/translate
    cp -R ../lib $out/share/ghdl_mcode/translate
    cp -R ../../libraries $out/share/ghdl_mcode

    mkdir -p $out/share/man/man1
    cp ../../doc/ghdl.1 $out/share/man/man1/ghdl_mcode.1

    # Ghdl has some timestamps checks, storing file timestamps in '.cf' files.
    # As we will change the timestamps to 1970-01-01 00:00:01, we also set the
    # content of that .cf to that value. This way ghdl does not complain on
    # the installed object files from the basic libraries (ieee, ...)
    pushd $out
    find . -name "*.cf" -exec \
        sed 's/[0-9]*\.000" /19700101000001.000" /g' -i {} \;
    popd
  '';

  meta = {
    homepage = "http://sourceforge.net/p/ghdl-updates/wiki/Home/";
    description = "Free VHDL simulator, mcode flavour";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
