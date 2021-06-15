{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "psysh";
  version = "0.10.8";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
    sha256 = "sha256-6opSBKR5eI5HlaJy4A94JrxYfUtCCNVlyntmLZbWfOE=";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    chmod +x $out/bin/psysh
    wrapProgram $out/bin/psysh --prefix PATH : "${lib.makeBinPath [ php ]}"
  '';

  meta = with lib; {
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = with maintainers; [ caugner ] ++ teams.php.members;
  };
}
