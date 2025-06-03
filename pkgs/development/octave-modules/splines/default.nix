{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "splines";
  version = "1.3.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-r4hod3l8OpyKNs59lGE8EFn3n6tIg0KeezKjsB4D16Y=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/splines/";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Additional spline functions";
  };
}
