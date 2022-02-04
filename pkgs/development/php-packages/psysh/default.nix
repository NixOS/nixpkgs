{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "psysh";
  version = "0.11.1";

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
    sha256 = "sha256-OiEXI7AVcC5udISfJ41285OBL82mSd1Xb5qhVtG4p9I=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    chmod +x $out/bin/psysh
    wrapProgram $out/bin/psysh --prefix PATH : "${lib.makeBinPath [ php ]}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    homepage = "https://github.com/bobthecow/psysh";
    license = licenses.mit;
    maintainers = with maintainers; [ caugner ] ++ teams.php.members;
  };
}
