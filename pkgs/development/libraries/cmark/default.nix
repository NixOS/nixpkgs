{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "0.28.3";
  name = "cmark-${version}";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = "cmark";
    rev = version;
    sha256 = "1lal6n6q7l84njgdcq1xbfxan56qlvr8xaw9m2jbd0jk4y2wkczg";
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
