{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "attr-2.4.48";

  src = fetchurl {
    url = "mirror://savannah/attr/${name}.tar.gz";
    sha256 = "1rr4adzwax4bzr2c00f06zcsljv5y6p9wymz1g89ww7cb2rp5bay";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ gettext ];

  postPatch = ''
    for script in install-sh include/install-sh; do
      patchShebangs $script
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://savannah.nongnu.org/projects/attr/";
    description = "Library and tools for manipulating extended attributes";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
