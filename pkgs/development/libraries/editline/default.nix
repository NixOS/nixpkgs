{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "editline-${version}";
  version = "1.16.0";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "0a751dp34mk9hwv59ss447csknpm5i5cgd607m3fqf24rszyhbf2";
  };

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/editline.html;
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
