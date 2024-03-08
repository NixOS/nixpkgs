{ buildOctavePackage
, lib
, fetchurl
, signal
, hdf5
}:

buildOctavePackage rec {
  pname = "communications";
  version = "1.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-psQuiBOI1mXXZaH4EesVO91r2ViCc0KrKxKM7Xw+gts=";
  };

  buildInputs = [
    hdf5
  ];

  requiredOctavePackages = [
    signal
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/communications/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = " Digital Communications, Error Correcting Codes (Channel Code), Source Code functions, Modulation and Galois Fields";
  };
}
