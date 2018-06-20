{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "editline-${version}";
  version = "1.15.3";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "0dm5fgq0acpprr938idwml64nclg9l6c6avirsd8r6f40qicbgma";
  };

  nativeBuildInputs = [ autoreconfHook ];

  dontDisableStatic = true;

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/editline.html;
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
