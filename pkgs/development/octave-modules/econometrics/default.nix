{
  buildOctavePackage,
  lib,
  fetchurl,
  optim,
}:

buildOctavePackage rec {
  pname = "econometrics";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1srx78k90ycla7yisa9h593n9l8br31lsdxlspra8sxiyq0sbk72";
  };

  requiredOctavePackages = [
    optim
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/econometrics/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Econometrics functions including MLE and GMM based techniques";
  };
}
