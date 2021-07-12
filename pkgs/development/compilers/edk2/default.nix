{
  stdenv,
  clangStdenv,
  fetchgit,
  fetchpatch,
  libuuid,
  python3,
  iasl,
  bc,
  clang_9,
  llvmPackages_9,
  overrideCC,
  lib,
}:

let
  pythonEnv = python3.withPackages (ps: [ps.tkinter]);

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else if stdenv.isAarch64 then
  "AARCH64"
else
  throw "Unsupported architecture";

buildStdenv = if stdenv.isDarwin then
  overrideCC clangStdenv [ clang_9 llvmPackages_9.llvm llvmPackages_9.lld ]
else
  stdenv;

buildType = if stdenv.isDarwin then
    "CLANGPDB"
  else
    "GCC5";

edk2 = buildStdenv.mkDerivation {
  pname = "edk2";
  version = "202102";

  # submodules
  src = fetchgit {
    url = "https://github.com/tianocore/edk2";
    rev = "edk2-stable${edk2.version}";
    sha256 = "1292hfbqz4wyikdf6glqdy80n9zpy54gnfngqnyv05908hww6h82";
  };

  buildInputs = [ libuuid pythonEnv ];

  makeFlags = [ "-C BaseTools" ]
    ++ lib.optional (stdenv.cc.isClang) [ "BUILD_CC=clang BUILD_CXX=clang++ BUILD_AS=clang" ];

  NIX_CFLAGS_COMPILE = "-Wno-return-type" + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel EFI development kit";
    homepage = "https://sourceforge.net/projects/edk2/";
    license = licenses.bsd2;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
  };

  passthru = {
    mkDerivation = projectDscPath: attrs: buildStdenv.mkDerivation ({
      inherit (edk2) src;

      buildInputs = [ bc pythonEnv ] ++ attrs.buildInputs or [];

      prePatch = ''
        rm -rf BaseTools
        ln -sv ${edk2}/BaseTools BaseTools
      '';

      configurePhase = ''
        runHook preConfigure
        export WORKSPACE="$PWD"
        . ${edk2}/edksetup.sh BaseTools
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        build -a ${targetArch} -b RELEASE -t ${buildType} -p ${projectDscPath} -n $NIX_BUILD_CORES $buildFlags
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mv -v Build/*/* $out
        runHook postInstall
      '';
    } // removeAttrs attrs [ "buildInputs" ]);
  };
};

in

edk2
