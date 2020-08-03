{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0sdqv4j1jjjc2nxnd9h7r4w66bdjl5ksvfia4i4cjj7jfl0hhynl";
  };

  configureFlags = [
    "--with-python=no"
  ];

  buildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
