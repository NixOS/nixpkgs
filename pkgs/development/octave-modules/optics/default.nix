{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "optics";
  version = "0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1d9z82241a1zmr8m1vgw10pyk81vn0q4dcyx7d05pigfn5gykrgc";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/optics/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Functions covering various aspects of optics";
  };
}
