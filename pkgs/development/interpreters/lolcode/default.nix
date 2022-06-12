{ lib, stdenv, fetchFromGitHub, pkg-config, doxygen, cmake, readline }:

with lib;
stdenv.mkDerivation rec {

  pname = "lolcode";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "justinmeza";
    repo = "lci";
    rev = "v${version}";
    sha256 = "sha256-VMBW3/sw+1kI6iuOckSPU1TIeY6QORcSfFLFkRYw3Gs=";
  };

  nativeBuildInputs = [ pkg-config cmake doxygen ];
  buildInputs = [ readline ];

  # Maybe it clashes with lci scientific logic software package...
  postInstall = "mv $out/bin/lci $out/bin/lolcode-lci";

  meta = {
    homepage = "http://lolcode.org";
    description = "An esoteric programming language";
    longDescription = ''
      LOLCODE is a funny esoteric  programming language, a bit Pascal-like,
      whose keywords are LOLspeak.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
    mainProgram = "lolcode-lci";
    platforms = lib.platforms.unix;
  };

}
