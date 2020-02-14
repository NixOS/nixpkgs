{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "metamath";
  version = "0.180";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "469e1b253f29be838411e2cc9c93d7704297059c";
    sha256 = "0nazi7z8qrpn7nnmxk99ilwf8smkzh26jcvn17wyfnywxpdsb7wa";
  };

  # the files necessary to build the DATA target are not in this distribution
  # luckily, they're not really needed so we don't build it.
  makeFlags = [ "DATA=" ];

  installTargets = [ "install-exec" ];

  meta = with stdenv.lib; {
    description = "Interpreter for the metamath proof language";
    longDescription = ''
      The metamath program is an ASCII-based ANSI C program with a command-line
      interface. It was used (along with mmj2) to build and verify the proofs
      in the Metamath Proof Explorer, and it generated its web pages. The *.mm
      ASCII databases (set.mm and others) are also included in this derivation.
    '';
    homepage = http://us.metamath.org;
    downloadPage = "http://us.metamath.org/#downloads";
    license = licenses.gpl2;
    maintainers = [ maintainers.taneb ];
    platforms = platforms.all;
  };
}
