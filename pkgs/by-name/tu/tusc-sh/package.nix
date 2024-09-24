{ lib
, stdenvNoCC
, fetchFromGitHub
, writeShellApplication
, curl
, coreutils
, jq
}:

let
  tusc = stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tusc-sh";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "adhocore";
    repo = "tusc.sh";
    rev = finalAttrs.version;
    hash = "sha256-EKlcE+rsVh5lUd8dQzAwXDjiUvrrud5yWfF6JWSZQFE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 tusc.sh -t $out/bin

    runHook postInstall
  '';

});
in
writeShellApplication {
  name = "tusc";
  runtimeInputs = [ tusc curl coreutils jq ];
  text = ''
    tusc.sh "$@"
  '';
  meta = with lib; {
    description = "Tus 1.0.0 client protocol implementation for bash";
    homepage = "https://github.com/adhocore/tusc.sh";
    changelog = "https://github.com/adhocore/tusc.sh/blob/${tusc.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "tusc";
    platforms = platforms.all;
  };
}
