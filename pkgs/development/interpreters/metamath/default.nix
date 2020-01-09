{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "metamath";
  version = "0.178";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "4f59d60aeb03f92aea3cc7ecf5a2c0fcf08900a5";
    sha256 = "0nrl4nzp6rm2sn365xyjf3g5l5fl58kca7rq08lqyz5gla0wgfcf";
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
