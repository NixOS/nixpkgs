{ stdenv, lib, fetchFromGitHub, pkg-config
, yosys, readline, zlib, ghdl
}:

stdenv.mkDerivation {
  pname = "yosys-ghdl";
  version = "2021.01.25";
  plugin = "ghdl";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl-yosys-plugin";
    rev    = "cba859cacf8c6631146dbdaa0f297c060b5a68cd";
    sha256 = "01d9wb7sqkmkf2y9bnn3pmhy08khzs5m1d06whxsiwgwnjzfk9mx";
  };

  buildInputs = [ yosys readline zlib ghdl ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;
  installPhase = ''
    mkdir -p $out/share/yosys/plugins
    cp ghdl.so $out/share/yosys/plugins/ghdl.so
  '';

  meta = with lib; {
    description = "GHDL plugin for Yosys";
    license     = licenses.isc;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
