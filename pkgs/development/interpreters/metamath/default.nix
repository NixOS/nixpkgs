{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "metamath-${version}";
  version = "0.171";

  buildInputs = [ autoreconfHook ];

  # This points to my own repository because there is no official repository
  # for metamath; there's a download location but it gets updated in place with
  # no permanent link. See discussion at
  # https://groups.google.com/forum/#!topic/metamath/N4WEWQQVUfY
  src = fetchFromGitHub {
    owner = "Taneb";
    repo = "metamath";
    rev = "1c622a844fbdee43f13a629c73d8b33ff7fc4e44";
    sha256 = "0bkz75saddlwinyqwmxx89nilaar401j63kgqfqiak8iw2nk3wln";
  };

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
