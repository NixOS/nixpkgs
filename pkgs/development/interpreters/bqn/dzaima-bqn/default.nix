{ lib
, stdenv
, fetchFromGitHub
, jdk
, makeWrapper
, buildNativeImage ? true
}:

stdenv.mkDerivation rec {
  pname = "dbqn" + lib.optionalString buildNativeImage "-native";
  version = "0.pre+date=2021-10-08";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN";
    rev = "0001109a1c5a420421b368c79d34b1e93bfe606e";
    hash = "sha256-riHHclTLkrVbtzmcz9ungAIc7kaoFHS77+SNatsfNhc=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs --build ./build8
  '';

  buildPhase = ''
    runHook preBuild

    ./build8
  '' + lib.optionalString buildNativeImage ''
    native-image --report-unsupported-elements-at-runtime \
      -H:CLibraryPath=${lib.getLib jdk}/lib -J-Dfile.encoding=UTF-8 \
      -jar BQN.jar dbqn
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
  };
}
# TODO: Processing app
# TODO: minimalistic JDK
