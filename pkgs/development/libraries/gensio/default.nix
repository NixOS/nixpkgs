{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1j6c6vmnip24pxafk29y312vif1xlryymv7aaxgqp9ca3s91nlrf";
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
