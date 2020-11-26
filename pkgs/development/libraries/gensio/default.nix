{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "07m8rbdk05biarc9xskwcx9lghj0dff1msxasfc6hi3jywc3xaih";
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
