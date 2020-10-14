{ stdenv, fetchzip, pkgs }:

stdenv.mkDerivation rec {
  pname = "pawn";
  version = "4.0.5749";

  src = fetchzip {
    url = "https://www.compuphase.com/${pname}/${pname}-${version}.zip";
    sha256 = "1qj2n0xql2bmgvng7q7xf7113bgi2kqgaq9jp0dmys3nc3vm123f";
    stripRoot = false;
  };
  buildInputs = with pkgs; [ cmake gcc_multi ];
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp pawncc $out/bin
    cp stategraph $out/bin
    cp pawndisasm $out/bin
    cp pawndbg $out/bin
    cp pawnrun $out/bin
    mkdir -p $out/lib
    cp *.so $out/lib
  '';

  meta = with stdenv.lib; {
    description = "A simple, typeless, 32-bit “scripting” language with a C-like syntax";
    longDescription = ''
      Pawn is a simple, typeless, 32-bit extension language with a C-like syntax.
      The Pawn compiler outputs P-code (or bytecode) that subsequently runs on an
      abstract machine. Execution speed, stability, simplicity and a small footprint
      were essential design criterions for both the language and the abstract
      machine.
    '';
    homepage = https://www.compuphase.com/pawn/pawn.htm;
    changelog = https://www.compuphase.com/pawn/pawnhistory.htm;
    license = [
      licenses.asl20
      {
        fullName = "An exception clause to explicitly permit static linking of the library to commercial application";
        url = "https://www.compuphase.com/pawn/pawn.htm#APACHE_EXCEPTION";
      }
    ];
    maintainers = [ maintainers.panurg ];
    platforms = platforms.all;
  };
}
