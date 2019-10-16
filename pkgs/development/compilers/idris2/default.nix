# racket is busted: https://github.com/NixOS/nixpkgs/issues/11698

{ stdenv, fetchFromGitHub, makeWrapper, runCommand
, idris, chez, racket, chickenPkgs
}:

stdenv.mkDerivation rec {

  pname = "idris2";

  src = fetchFromGitHub {
    owner = "edwinb";
    repo = "Idris2";
    rev = "bf5b2298e068ebeaddd70b695426f52ebe67c1ab";
    sha256 = "1ixmdy4zbllmpwmvmmqv1rj9a2y243pggf42pdqkvrkjw50zqlyj";
  };

  version = "0.0.0";

  nativeBuildInputs = [ idris makeWrapper ];

  propagatedBuildInputs =
    [ chez
      racket
      chickenPkgs.chicken
      chickenPkgs.chickenEggs.numbers ];

  makeFlags = [ "PREFIX=$(out)" ];

  # The `network` library generates a test at build time, so we need to help it
  # find the Chez binary.
  CHEZ = "${chez}/bin/scheme";

  postPatch = ''
    patchShebangs tests/ideMode/ideMode002/gen_expected.sh
  '';

  postInstall = ''
    wrapProgram $out/bin/idris2 \
      --set CHEZ ${chez}/bin/scheme \
      --set RACKET ${racket}/bin/racket \
      --set RACKET_RACO ${racket}/bin/raco \
      --set CHICKEN_CSI ${chickenPkgs.chicken}/bin/csi \
      --set CHICKEN_CSC ${chickenPkgs.chicken}/bin/csc
  '';

  meta = {
    description = "A dependently typed programming language";
    homepage = https://github.com/edwinb/Idris2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ lodi ];
  };

}
