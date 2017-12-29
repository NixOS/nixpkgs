{ stdenv, fetchFromGitHub, gnat, zlib, llvm_35, ncurses, clang, flavour ? "mcode" }:

# mcode only works on x86, while the llvm flavour works on both x86 and x86_64.


assert flavour == "llvm" || flavour == "mcode";

let
  inherit (stdenv.lib) optional;
  inherit (stdenv.lib) optionals;
  version = "0.33";
in
stdenv.mkDerivation rec {
  name = "ghdl-${flavour}-${version}";

  src = fetchFromGitHub {
    owner = "tgingold";
    repo = "ghdl";
    rev = "v${version}";
    sha256 = "0g72rk2yzr0lrpncq2c1qcv71w3mi2hjq84r1yzgjr6d0qm87r2a";
  };

  buildInputs = [ gnat zlib ] ++ optionals (flavour == "llvm") [ clang ncurses ];

  configureFlags = optional (flavour == "llvm") "--with-llvm=${llvm_35}";

  patchPhase = ''
    # Disable warnings-as-errors, because there are warnings (unused things)
    sed -i s/-gnatwae/-gnatwa/ Makefile.in ghdl.gpr.in
  '';

  hardeningDisable = [ "all" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://sourceforge.net/p/ghdl-updates/wiki/Home/;
    description = "Free VHDL simulator";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; (if flavour == "llvm" then [ "i686-linux" "x86_64-linux" ]
      else [ "i686-linux" ]);
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
