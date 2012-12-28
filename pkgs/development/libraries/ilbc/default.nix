{ stdenv, fetchurl, gawk, cmake }:

stdenv.mkDerivation rec {
  name = "ilbc-rfc3951";

  script = fetchurl {
    url = http://ilbcfreeware.org/documentation/extract-cfile.txt;
    name = "extract-cfile.awk";
    sha256 = "0md76qlszaras9grrxaq7xfxn1yikmz4qqgnjj6y50jg31yr5wyd";
  };

  rfc3951 = fetchurl {
    url = http://www.ietf.org/rfc/rfc3951.txt;
    sha256 = "0zf4mvi3jzx6zjrfl2rbhl2m68pzbzpf1vbdmn7dqbfpcb67jpdy";
  };

  nativeBuildInputs = [ cmake ];

  unpackPhase = ''
    mkdir -v ${name}
    cd ${name}
    ${gawk}/bin/gawk -f ${script} ${rfc3951}
    cp -v ${./CMakeLists.txt} CMakeLists.txt
    '';

}
