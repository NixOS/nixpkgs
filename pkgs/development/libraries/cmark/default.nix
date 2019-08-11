{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "0.29.0";
  name = "cmark-${version}";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "cmark";
    rev = version;
    sha256 = "0r7jpqhgnssq444i8pwji2g36058vfzwkl70wbiwj13h4w5rfc8f";
  };

  nativeBuildInputs = [ cmake ];
  doCheck = !stdenv.isDarwin;
  preCheck = ''
    export LD_LIBRARY_PATH=$(readlink -f ./src)
  '';

  meta = with stdenv.lib; {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = https://github.com/jgm/cmark;
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
