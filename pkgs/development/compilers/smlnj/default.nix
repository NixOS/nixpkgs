{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  automake,
  autoconf,
  cmake,
  versionCheckHook,
}:
let
  version = "2026.2";
  src = fetchFromGitHub {
    owner = "smlnj";
    repo = "smlnj";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-1oiDdiGZvg8Dlz3InFLjOilvBTShuTFHz91Xmc1onMA=";
  };

  llvm = callPackage ./llvm.nix { inherit src version; };

  bootFile =
    if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isx86_64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.amd64-unix.tgz";
        hash = "sha256-ug2Busk6aYeqEGh923ZG8c3xw1Cjmct2Fxv7K44cjOs=";
      }
    else if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.arm64-unix.tgz";
        hash = "sha256-UQ8GxaabgJ3QoH6hlnWCNSsxyR73H2VdKsbsgt376k0=";
      }
    else
      throw "Unsupported host platform: ${stdenv.hostPlatform.config}";

in
stdenv.mkDerivation {
  pname = "smlnj";
  inherit src version;

  nativeBuildInputs = [
    autoconf
    automake
    cmake
  ];

  __structuredAttrs = true;
  strictDeps = true;

  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    unpackFile ${bootFile}
    mkdir -pv $out/bin $out/lib bin lib
    ln -s ${llvm}/bin/llvm-config     bin/llvm-config
    ln -s ${llvm}/bin/llvm-config     $out/bin/llvm-config
    ln -s ${llvm}/lib/libCFGCodeGen.a lib/libCFGCodeGen.a
    ln -s ${llvm}/lib/libCFGCodeGen.a $out/lib/libCFGCodeGen.a

    ./build.sh -install $out

    rm $out/bin/llvm-config $out/lib/libCFGCodeGen.a

    runHook postBuild
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "@SMLversion";
  doInstallCheck = true;

  passthru.llvm = llvm;

  meta = {
    description = "Standard ML of New Jersey, a Standard ML compiler";
    homepage = "https://smlnj.org";
    downloadPage = "https://smlnj.org/dist/working/${version}/install.html";
    changelog = "https://smlnj.org/dist/working/${version}/README.html";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "sml";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
}
