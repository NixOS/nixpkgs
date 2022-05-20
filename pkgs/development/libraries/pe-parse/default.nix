{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "pe-parse";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "v${version}";
    hash = "sha256-HwWlMRhpB/sa/JRyAZF7LZzkXCCyuxB+gtDAfHt7e6k=";
  };

  nativeBuildInputs = [ cmake ];

  # See https://github.com/trailofbits/pe-parse/issues/169
  NIX_CFLAGS_COMPILE = "-Wno-sign-conversion";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dump-pe ../tests/assets/example.exe
  '';

  meta = with lib; {
    description = "A principled, lightweight parser for Windows portable executable files";
    homepage = "https://github.com/trailofbits/pe-parse";
    license = licenses.mit;
    maintainers = with maintainers; [ arturcygan ];
    mainProgram = "dump-pe";
    platforms = platforms.unix;
  };
}
