{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "psysh";
  version = "0.10.4";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
    sha256 = "005xh5rz12bsy9yvzzr69zpr0p7v4sh6cafhpinpfrvbwfq068f1";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    chmod +x $out/bin/psysh
    wrapProgram $out/bin/psysh --prefix PATH : "${lib.makeBinPath [ php ]}"
  '';

  meta = with pkgs.lib; {
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = with maintainers; [ caugner ] ++ teams.php.members;
  };
}
