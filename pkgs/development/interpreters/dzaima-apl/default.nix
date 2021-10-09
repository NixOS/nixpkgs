{ lib
, stdenv
, fetchFromGitHub
, jdk
, makeWrapper
, buildNativeImage ? true
}:

stdenv.mkDerivation rec {
  pname = "dapl" + lib.optionalString buildNativeImage "-native";
  version = "0.2.0+unstable=2021-06-30";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "APL";
    rev = "28b3667beb23c6472266bb2b6eb701708fa421c6";
    hash = "sha256-2kM9XDMclxJNOZngwLvoDQG23UZQQ6ePK/j215UumCg=";
  };

  nativeBuildInputs = [
    makeWrapper
    jdk
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    patchShebangs --build ./build
    ./build
  '' + lib.optionalString buildNativeImage ''
    native-image --report-unsupported-elements-at-runtime \
      -H:CLibraryPath=${lib.getLib jdk}/lib -jar APL.jar dapl
  '' + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
  '' + (if buildNativeImage then ''
    mv dapl $out/bin
  '' else ''
    mkdir -p $out/share/${pname}
    mv APL.jar $out/share/${pname}/

    makeWrapper "${lib.getBin jdk}/bin/java" "$out/bin/dapl" \
      --add-flags "-jar $out/share/${pname}/APL.jar"
  '') + ''
    ln -s $out/bin/dapl $out/bin/apl

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/APL";
    description = "An APL implementation in Java" + lib.optionalString buildNativeImage ", compiled as a native image";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (jdk.meta) platforms;
  };
}
# TODO: Processing app
# TODO: minimalistic JDK
