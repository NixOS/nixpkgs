{ stdenv, fetchFromGitHub, cmake, bison, flex }:

stdenv.mkDerivation rec {
  name = "libcue-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${version}";
    sha256 = "0znn9scamy1nsz1dzvsamqg46zr7ldfvpxiyzi1ss9d6gbcm0frs";
  };

  nativeBuildInputs = [ cmake bison flex ];

  meta = with stdenv.lib; {
    description = "CUE Sheet Parser Library";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = https://sourceforge.net/projects/libcue/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
