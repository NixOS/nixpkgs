{ stdenv, fetchurl, gnat, zlib }:
let
  version = "0.33";
in
stdenv.mkDerivation rec {
  name = "ghdl-mcode-${version}";

  src = fetchurl {
    url = "https://github.com/tgingold/ghdl/archive/v${version}.tar.gz";
    sha256 = "09yvgqyglbakd74v2dgr470clzm744i232nixyffcds55vkij5da";
  };

  buildInputs = [ gnat zlib ];

  patchPhase = ''
    # Disable warnings-as-errors, because there are warnings (unused things)
    sed -i s/-gnatwae/-gnatwa/ Makefile.in ghdl.gpr.in
  '';

  hardeningDisable = [ "all" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://sourceforge.net/p/ghdl-updates/wiki/Home/";
    description = "Free VHDL simulator, mcode flavour";
    maintainers = with stdenv.lib.maintainers; [viric];
    # I think that mcode can only generate x86 code,
    # so it fails to link pieces on x86_64.
    platforms = with stdenv.lib.platforms; [ "i686-linux" ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
