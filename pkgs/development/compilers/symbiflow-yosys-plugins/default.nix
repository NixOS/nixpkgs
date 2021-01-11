{ stdenv
, fetchFromGitHub
, symbiflow-yosys
, zlib
, readline
}:

stdenv.mkDerivation rec {
  pname   = "symbiflow-yosys-plugins";
  version = "1.0.0.7-0060-g7454cd6b";

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "yosys-symbiflow-plugins";
    rev    = "7454cd6b5e4fd22854e2ada219a5e3c3a06e0717";
    sha256 = "0r9r31p7fy4ylfrwvwlbivq5a03xrph34blxbxzx2c8bc02mbv0s";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ symbiflow-yosys ];

  buildInputs = [
    readline
    zlib
  ];

  makeFlags = [ "PLUGINS_DIR=${placeholder "out"}/share/yosys/plugins" ];

  meta = with stdenv.lib; {
    description = "Yosys SymbiFlow Plugins";
    homepage    = "https://github.com/SymbiFlow/yosys-symbiflow-plugins";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ mcaju ];
  };
}
