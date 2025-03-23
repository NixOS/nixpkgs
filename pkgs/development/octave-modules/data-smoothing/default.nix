{
  buildOctavePackage,
  lib,
  fetchurl,
  optim,
}:

buildOctavePackage rec {
  pname = "data-smoothing";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0q0vqdmp8ygyfhk296xbxcpsh5wvpa2kfgv4v0rys68nd2lxfaq1";
  };

  requiredOctavePackages = [
    optim
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/data-smoothing/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Algorithms for smoothing noisy data";
  };
}
