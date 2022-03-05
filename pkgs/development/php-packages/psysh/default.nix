{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "psysh";
  version = "0.11.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
    sha256 = "sha256-OiEXI7AVcC5udISfJ41285OBL82mSd1Xb5qhVtG4p9I=";
  };

  dontUnpack = true;

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
