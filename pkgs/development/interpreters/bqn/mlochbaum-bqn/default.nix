{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bqn";
  version = "unstable-2023-05-17";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "070bd07dc10c291695215265218ec0ff856ce457";
    hash = "sha256-GRIIzJwlJ+JTBHXZjoX/9vLFbAC7zyeuqVcrA/Jm/NA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ nodejs ];

  patches = [
    # Creates a @libbqn@ substitution variable, to be filled in the fixupPhase
    ./001-libbqn-path.patch
  ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp bqn.js $out/share/${pname}/bqn.js
    cp docs/bqn.js $out/share/${pname}/libbqn.js

    makeWrapper "${lib.getBin nodejs}/bin/node" "$out/bin/mbqn" \
      --add-flags "$out/share/${pname}/bqn.js"

    ln -s $out/bin/mbqn $out/bin/bqn

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/share/${pname}/bqn.js \
      --subst-var-by "libbqn" "$out/share/${pname}/libbqn.js"

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://github.com/mlochbaum/BQN/";
    description = "The original BQN implementation in Javascript";
    license = licenses.isc;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
# TODO: install docs and other stuff
