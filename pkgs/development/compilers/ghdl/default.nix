{ stdenv, fetchurl, gnat, zlib, llvm_35, ncurses, clang, flavour ? "mcode" }:

# mcode only works on x86, while the llvm flavour works on both x86 and x86_64.


assert flavour == "llvm" || flavour == "mcode";

let
  optional = stdenv.lib.optional;
  version = "0.33";
in
stdenv.mkDerivation rec {
  name = "ghdl-${version}";

  src = fetchurl {
    url = "https://github.com/tgingold/ghdl/archive/v${version}.tar.gz";
    sha256 = "09yvgqyglbakd74v2dgr470clzm744i232nixyffcds55vkij5da";
  };

  buildInputs = [ gnat zlib ] ++ optional (flavour == "llvm") [ clang ncurses ];

  configureFlags = optional (flavour == "llvm") "--with-llvm=${llvm_35}";

  patchPhase = ''
    # Disable warnings-as-errors, because there are warnings (unused things)
    sed -i s/-gnatwae/-gnatwa/ Makefile.in ghdl.gpr.in
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://sourceforge.net/p/ghdl-updates/wiki/Home/";
    description = "Free VHDL simulator";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; (if flavour == "llvm" then [ "i686-linux" "x86_64-linux" ]
      else [ "i686-linux" ]);
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
