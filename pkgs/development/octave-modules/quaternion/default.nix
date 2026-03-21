{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "quaternion";
  version = "2.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-S8tkdDlyaT8E7W0v6kkGs4qTU/G4DG5vLQvA9vjPOgc=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/quaternion/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Quaternion package for GNU Octave, includes a quaternion class with overloaded operators";
  };
}
