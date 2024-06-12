{ lib
, stdenv
, fetchurl
, v4l-utils
}:

stdenv.mkDerivation rec {
  pname = "dtv-scan-tables";
  version = "2022-04-30-57ed29822750";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-amJoqjkkWTePo6E5IvwBWj+mP/gi9LDWTTPXE1Cm7J4=";
  };

  nativeBuildInputs = [
    v4l-utils
  ];

  sourceRoot = "usr/share/dvb";

  makeFlags = [
    "PREFIX=$(out)"
  ];

  allowedReferences = [ ];

  meta = with lib; {
    # git repo with current revision is here:
    #downloadPage = "https://git.linuxtv.org/dtv-scan-tables.git";
    # Weekly releases are supposed to be here
    downloadPage = "https://linuxtv.org/downloads/dtv-scan-tables/";
    # but sometimes they lag behind several weeks or even months.
    description = "Digital TV (DVB) channel/transponder scan tables";
    homepage = "https://www.linuxtv.org/wiki/index.php/Dtv-scan-tables";
    license = with licenses; [ gpl2Only lgpl21Only ];
    longDescription = ''
      When scanning for dvb channels,
      most applications require an initial set of
      transponder coordinates (frequencies etc.).
      These coordinates differ, depending of the
      receiver's location or on the satellite.
      The package delivers a collection of transponder
      tables ready to be used by software like "dvbv5-scan".
    '';
    maintainers = with maintainers; [ yarny ];
  };
}
