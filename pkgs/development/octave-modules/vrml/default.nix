{
  buildOctavePackage,
  lib,
  fetchurl,
  # Octave dependencies
  linear-algebra,
  miscellaneous,
  struct,
  statistics,
  # Runtime dependencies
  freewrl,
}:

buildOctavePackage rec {
  pname = "vrml";
  version = "1.0.14";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Vfj0Q2CyOi7CrphZSl10Xv7QxTSvWdGk0Ya+SiewqV4=";
  };

  propagatedBuildInputs = [
    freewrl
  ];

  requiredOctavePackages = [
    linear-algebra
    miscellaneous
    struct
    statistics
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/vrml/";
    license = with lib.licenses; [
      gpl3Plus
      fdl12Plus
    ];
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "3D graphics using VRML";
    # Marked this way until KarlJoad gets freewrl as a runtime dependency.
    broken = true;
  };
}
