{ stdenv
, clangStdenv
, fetchFromGitHub
, fetchpatch
, libuuid
, python3
, bc
, llvmPackages_9
, lib
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
  llvmPackages_9.stdenv
else
  stdenv;

buildType = if stdenv.isDarwin then
    "CLANGPDB"
  else
    "GCC5";

edk2 = buildStdenv.mkDerivation {
  pname = "edk2";
  version = "202108";

  # submodules
  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "edk2-stable${edk2.version}";
    fetchSubmodules = true;
    sha256 = "1ps244f7y43afxxw6z95xscy24f9mpp8g0mfn90rd4229f193ba2";
  };

  patches = [
    # Pull upstream fix for gcc-11 build.
    (fetchpatch {
      name = "gcc-11-vla.patch";
      url = "https://github.com/google/brotli/commit/0a3944c8c99b8d10cc4325f721b7c273d2b41f7b.patch";
      sha256 = "10c6ibnxh4f8lrh9i498nywgva32jxy2c1zzvr9mcqgblf9d19pj";
      # Apply submodule patch to subdirectory: "a/" -> "BaseTools/Source/C/BrotliCompress/brotli/"
      stripLen = 1;
      extraPrefix = "BaseTools/Source/C/BrotliCompress/brotli/";
    })
  ];

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
