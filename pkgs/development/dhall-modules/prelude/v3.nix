{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "dhall-prelude";

  src = fetchFromGitHub {
    owner = "dhall-lang";
    repo = "dhall-lang";
    # Commit where the v3.0.0 prelude folder was merged into dhall-lang
    # and a LICENSE file has been added.
    rev = "f6aa9399f1ac831d66c34104abe6856023c5b2df";
    sha256 = "0kqjgh3y1l3cb3rj381j7c09547g1vh2dsfzpm08y1qajhhf9vgf";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -r Prelude $out
  '';

  meta = {
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Profpatsch ];
  };
}
