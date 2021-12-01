{ buildOctavePackage
, lib
, fetchurl
, control
}:

buildOctavePackage rec {
  pname = "signal";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1amfh7ifjqxz2kr34hgq2mq8ygmd5j3cjdk1k2dk6qcgic7n0y6r";
  };

  requiredOctavePackages = [
    control
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/signal/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Signal processing tools, including filtering, windowing and display functions";
  };
}
