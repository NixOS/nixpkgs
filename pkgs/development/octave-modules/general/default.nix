{
  buildOctavePackage,
  lib,
  fetchurl,
  pkg-config,
  nettle,
}:

buildOctavePackage rec {
  pname = "general";
  version = "2.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-amslJm3haXaAehdm6jYJxcGZl+ggUcnJc3i6YJ3QkyM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    nettle
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/general/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "General tools for Octave";
  };
}
