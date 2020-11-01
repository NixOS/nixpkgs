{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c44qhhrknjl7sp94q34z7nv7bvnlqs8wzm385661liy4mnfn4dc";
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
