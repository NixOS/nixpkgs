{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "psysh";
  version = "0.10.3";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
    sha256 = "0glply451fy0g7zbasyp350qvmk2aglrlcrcdd7w0igylgwfkg71";
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
