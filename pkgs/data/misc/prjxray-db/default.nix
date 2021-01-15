{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname   = "prjxray-db";
  version = "0.0-0232-g303a61d";

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "prjxray-db";
    rev    = "303a61d8bc552f7a533b91b17448c59e908aa391";
    sha256 = "0r75xig16dbgh3nfygggir0a160x52y766h7hd9xcib9m88jixb2";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    DBDIR="$out/share/symbiflow/prjxray-db/"
    DB_CONFIG="$out/bin/prjxray-config"

    mkdir -p $DBDIR $out/bin

    for device in artix7 kintex7 zynq7; do
      cp -r $src/$device $DBDIR
    done

    echo -e "#!/bin/sh\n\necho $DBDIR" > $DB_CONFIG
    chmod +x $DB_CONFIG

    runHook postInstall
  '';

  meta = with lib; {
    description = "Project X-Ray - Xilinx Series 7 Bitstream Documentation";
    homepage    = "https://github.com/SymbiFlow/prjxray-db";
    license     = licenses.cc0;
    maintainers = with maintainers; [ mcaju ];
    platforms   = platforms.all;
  };
}
