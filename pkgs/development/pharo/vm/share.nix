{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "pharo-share-${version}";

  src = ./resources;

  sources10Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV10.sources.zip;
    sha256 = "0aijhr3w5w3jzmnpl61g6xkwyi2l1mxy0qbvr9k3whz8zlrsijh2";
  };

  sources20Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV20.sources.zip;
    sha256 = "1xsc0p361pp8iha5zckppw29sbapd706wbvzvgjnkv2n6n1q5gj7";
  };

  sources30Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV30.sources.zip;
    sha256 = "08d9a7gggwpwgrfbp7iv5896jgqz3vgjfrq19y3jw8k10pva98ak";
  };

  sources40Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV40.sources.zip;
    sha256 = "1xq1721ql19hpgr8ir372h92q7g8zwd6k921b21dap4wf8djqnpd";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $prefix/lib

    cp -R "$src/"* "$prefix/"

    unzip ${sources10Zip} -d $prefix/lib/
    unzip ${sources20Zip} -d $prefix/lib/
    unzip ${sources30Zip} -d $prefix/lib/
    unzip ${sources40Zip} -d $prefix/lib/
  '';

  meta = {
    description = "Shared files for Pharo";
    homepage = http://pharo.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.DamienCassou ];
  };
}
