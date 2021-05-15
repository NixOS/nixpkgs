{ buildOctavePackage
, lib
, fetchurl
, signal
, hdf5
}:

buildOctavePackage rec {
  pname = "communications";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1xay2vjyadv3ja8dmqqzm2his8s0rvidz23nq1c2yl3xh1gavyck";
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
