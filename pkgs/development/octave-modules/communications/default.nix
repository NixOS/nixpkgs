{ buildOctavePackage
, lib
, fetchurl
, signal
, hdf5
}:

buildOctavePackage rec {
  pname = "communications";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1r4r0cia5l5fann1n78c1qdc6q8nizgb09n2fdwb76xnwjan23g3";
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
