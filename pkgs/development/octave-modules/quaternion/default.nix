{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "quaternion";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "040ncksf0xz32qmi4484xs3q01nappxrsvwwa60g04yjy7c4sbac";
  };

  # Octave replaced many of the is_thing_type check function with isthing.
  # The patch changes the occurrences of the old functions.
  patchPhase = ''
    sed -i s/is_numeric_type/isnumeric/g src/*.cc
    sed -i s/is_real_type/isreal/g src/*.cc
    sed -i s/is_bool_type/islogical/g src/*.cc
  '';

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/quaternion/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Quaternion package for GNU Octave, includes a quaternion class with overloaded operators";
  };
}
