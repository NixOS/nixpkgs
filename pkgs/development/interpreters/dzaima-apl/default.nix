{ lib
, stdenv
, fetchFromGitHub
, jdk
, makeWrapper
, buildNativeImage ? true
}:

stdenv.mkDerivation rec {
  pname = "dapl" + lib.optionalString buildNativeImage "-native";
  version = "0.2.0+date=2021-10-16";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "APL";
    rev = "5eb0a4205e27afa6122096a25008474eec562dc0";
    hash = "sha256-UdumMytqT909JRpNqzhYPuKPw644m/vRUsEbIVF2a7U=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  dontConfigure = true;

  postPatch = ''
    patchShebangs --build ./build
  '';

  buildPhase = ''
    runHook preBuild

    ./build
  '' + lib.optionalString buildNativeImage ''
    native-image --report-unsupported-elements-at-runtime \
      -H:CLibraryPath=${lib.getLib jdk}/lib -J-Dfile.encoding=UTF-8 \
      -jar APL.jar dapl
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
    description = "APL implementation in Java" + lib.optionalString buildNativeImage ", compiled as a native image";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (jdk.meta) platforms;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/dapl-native.x86_64-darwin
  };
}
# TODO: Processing app
# TODO: minimalistic JDK
