{ stdenv, fetchurl, gawk, cmake }:

stdenv.mkDerivation rec {
  name = "ilbc-rfc3951";

  script = fetchurl {
    url = http://ilbcfreeware.org/documentation/extract-cfile.awk;
    sha256 = "155izy7p7azak1h6bgafvh84b1605zyw14k2s4pyl5nd4saap5c6";
  };

  rfc3951 = fetchurl {
    url = http://www.ietf.org/rfc/rfc3951.txt;
    sha256 = "0zf4mvi3jzx6zjrfl2rbhl2m68pzbzpf1vbdmn7dqbfpcb67jpdy";
  };

  buildNativeInputs = [ cmake ];

  unpackPhase = ''
    mkdir -v ${name}
    cd ${name}
    ${gawk}/bin/gawk -f ${script} ${rfc3951}
    cp -v ${./CMakeLists.txt} CMakeLists.txt
    '';

}
