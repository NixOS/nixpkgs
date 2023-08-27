{ stdenv
, fetchurl
, gmp
, lib
}: stdenv.mkDerivation (final: {
  pname = "TOPCOM";
  version = "1.1.2";

  src = fetchurl {
    url = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-${builtins.replaceStrings ["."] ["_"] final.version}.tgz";
    hash = "sha256-T7EHVO5bdgVkQf6pjyyN7l228phNjBQoO0kjmtQ3irY=";
  };

  buildInputs = [
    gmp
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Triangulations Of Point Configurations and Oriented Matroids";
    homepage = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ alois31 ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
