{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "metamath";
  version = "0.182";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "5df616efe4119ff88daf77e7041d45b6fa39c578";
    sha256 = "0amjdgy42c7jypf6sz98iczlxcyl9bqx67ws1q8w2zdqk2izsyjp";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the metamath proof language";
    longDescription = ''
      The metamath program is an ASCII-based ANSI C program with a command-line
      interface. It was used (along with mmj2) to build and verify the proofs
      in the Metamath Proof Explorer, and it generated its web pages. The *.mm
      ASCII databases (set.mm and others) are also included in this derivation.
    '';
    homepage = "http://us.metamath.org";
    downloadPage = "http://us.metamath.org/#downloads";
    license = licenses.gpl2;
    maintainers = [ maintainers.taneb ];
    platforms = platforms.all;
  };
}
