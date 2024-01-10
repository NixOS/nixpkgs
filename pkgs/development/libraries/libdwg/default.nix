{lib, stdenv, fetchurl, indent}:

stdenv.mkDerivation rec {
  pname = "libdwg";
  version = "0.6";

  src = fetchurl {
    url = "mirror://sourceforge/libdwg/libdwg-${version}.tar.bz2";
    sha256 = "0l8ks1x70mkna1q7mzy1fxplinz141bd24qhrm1zkdil74mcsryc";
  };

  nativeBuildInputs = [ indent ];

  hardeningDisable = [ "format" ];

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  meta = {
    description = "Library reading dwg files";
    homepage = "http://libdwg.sourceforge.net/en/";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.linux;
  };
}
