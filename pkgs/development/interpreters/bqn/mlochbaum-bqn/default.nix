{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, nodejs
}:

stdenvNoCC.mkDerivation rec {
  pname = "bqn";
  version = "0.pre+date=2022-11-24";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "976bd82fb0e830876cca117c302c8a19048033a4";
    hash = "sha256:1nhn30ypc2zvq58b3zi66ypc9wv3v8cryn43cqihazc1lq8qxqdw";
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
