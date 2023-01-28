{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "metamath";
  version = "0.198";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "v${version}";
    sha256 = "sha256-Cg1dgz+uphDlGhKH3mTywtAccWinC5+pwNv4TB3YAnI=";
  };

  meta = with lib; {
    description = "Interpreter for the metamath proof language";
    longDescription = ''
      The metamath program is an ASCII-based ANSI C program with a command-line
      interface. It was used (along with mmj2) to build and verify the proofs
      in the Metamath Proof Explorer, and it generated its web pages. The *.mm
      ASCII databases (set.mm and others) are also included in this derivation.
    '';
    homepage = "http://us.metamath.org";
    downloadPage = "https://us.metamath.org/#downloads";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.taneb ];
    platforms = platforms.all;
  };
}
