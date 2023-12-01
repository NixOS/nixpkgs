{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "pe-parse";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "v${version}";
    hash = "sha256-XegSZWRoQg6NEWuTSFI1RMvN3GbpLDrZrloPU2XdK2M=";
  };

  nativeBuildInputs = [ cmake ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dump-pe ../tests/assets/example.exe
  '';

  meta = with lib; {
    description = "A principled, lightweight parser for Windows portable executable files";
    homepage = "https://github.com/trailofbits/pe-parse";
    changelog = "https://github.com/trailofbits/pe-parse/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ arturcygan ];
    mainProgram = "dump-pe";
    platforms = platforms.unix;
  };
}
