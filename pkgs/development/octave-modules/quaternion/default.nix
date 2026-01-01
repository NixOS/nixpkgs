{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "quaternion";
<<<<<<< HEAD
  version = "2.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-kY5mU7dJuUjprub+LTc1BH6YGdEnP9ydX0lRU0fmOYE=";
=======
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "040ncksf0xz32qmi4484xs3q01nappxrsvwwa60g04yjy7c4sbac";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Octave replaced many of the is_thing_type check function with isthing.
  # The patch changes the occurrences of the old functions.
  patchPhase = ''
    sed -i s/is_numeric_type/isnumeric/g src/*.cc
    sed -i s/is_real_type/isreal/g src/*.cc
    sed -i s/is_bool_type/islogical/g src/*.cc
  '';

  meta = {
    homepage = "https://gnu-octave.github.io/packages/quaternion/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Quaternion package for GNU Octave, includes a quaternion class with overloaded operators";
  };
}
