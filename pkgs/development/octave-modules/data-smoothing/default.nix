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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/data-smoothing/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Algorithms for smoothing noisy data";
  };
}
