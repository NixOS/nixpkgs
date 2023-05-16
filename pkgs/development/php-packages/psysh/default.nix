{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "psysh";
<<<<<<< HEAD
  version = "0.11.20";
=======
  version = "0.11.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-1d07/qE6qamsmBkkuuxIY9YgYC7wgP21QDc5Iu9Ecv4=";
=======
    sha256 = "sha256-4FEjMtp7MRTjpdb1ZpKqCa0erxrW90JyGy1ZmMBVdZE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/bobthecow/psysh/releases/tag/v${version}";
    description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
    license = licenses.mit;
    homepage = "https://psysh.org/";
    maintainers = teams.php.members;
  };
}
