{ stdenv
, fetchFromGitHub
, bison
, cmake
, flex
, pkg-config
}:

stdenv.mkDerivation rec {
  pname   = "symbiflow-vtr";
  version = "8.0.0.rc2-4003-g8980e4621";

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "vtr-verilog-to-routing";
    rev    = "8980e46218542888fac879961b13aa7b0fba8432";
    sha256 = "1sq7f1f3dzfm48a9vq5nvp0zllby0nasm3pvqab70f4jaq0m1aaa";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  cmakeFlags = [
    "-DWITH_ODIN=OFF"
    "-DWITH_ABC=OFF"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "SymbiFlow WIP changes for Verilog to Routing (VTR)";
    homepage    = "https://github.com/SymbiFlow/vtr-verilog-to-routing";
    platforms   = platforms.all;
    maintainers = with maintainers; [ mcaju ];
  };
}
