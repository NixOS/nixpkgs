{ stdenv, fetchFromGitHub, cmake, bison, flex }:
stdenv.mkDerivation rec {
  name = "libcue-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${version}";
    sha256 = "14a84d6sq3yp8s8i05lxvifjpkgpjwfpchrqf3bbpbwa8gvrc0rj";
  };

  nativeBuildInputs = [ cmake bison flex ];

  meta = {
    description = "CUE Sheet Parser Library";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = http://sourceforge.net/projects/libcue/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
