{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "metamath";
  version = "0.181";

  buildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "67cbfa8468deb6f8ad5bedafc6399bee59064764";
    sha256 = "1mk3g41qz26j38j68i9qmnl8khkd8jwrzj4vxkb855h4b819s000";
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
