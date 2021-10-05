{ lib
, stdenv
, fetchFromGitHub
, jdk
, makeWrapper
, buildNativeImage ? true
}:

stdenv.mkDerivation rec {
  pname = "dbqn" + lib.optionalString buildNativeImage "-native";
  version = "0.0.0+unstable=2021-10-02";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN";
    rev = "d6bd66d26a89b8e9f956ec4f6b6bc5dcb5861a09";
    hash = "sha256-BLRep7OGHfDFowIAsBS19PTzgIhrdKMnO2JSjKuwGYo=";
  };

  buildInputs = lib.optional (!buildNativeImage) jdk;

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional buildNativeImage jdk;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p output
    javac --release 8 -encoding UTF-8 -d ./output $(find src -name '*.java')
    (cd output; jar cvfe ../BQN.jar BQN.Main *)
    rm -fr output
  '' + lib.optionalString buildNativeImage ''
    native-image --report-unsupported-elements-at-runtime \
      -J-Dfile.encoding=UTF-8 -jar BQN.jar dbqn
  '' + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

  '' + (if buildNativeImage then ''
    mv dbqn $out/bin
  '' else ''
    mkdir -p $out/share/${pname}
    mv BQN.jar $out/share/${pname}/

    makeWrapper "${lib.getBin jdk}/bin/java" "$out/bin/dbqn" \
      --add-flags "-jar $out/share/${pname}/BQN.jar"
  '') + ''
    ln -s $out/bin/dbqn $out/bin/bqn

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/BQN";
    description = "A BQN implementation in Java" + lib.optionalString buildNativeImage ", compiled as a native image";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres sternenseemann ];
    inherit (jdk.meta) platforms;
    priority = if buildNativeImage then 10 else 0;
  };
}
# TODO: Processing app
# TODO: minimalistic JDK
