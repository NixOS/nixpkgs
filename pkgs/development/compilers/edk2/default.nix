{ stdenv
, clangStdenv
, fetchFromGitHub
, fetchpatch
, libuuid
, python3
, bc
, llvmPackages_9
, lib
, buildPackages
}:

let
  pythonEnv = buildPackages.python3.withPackages (ps: [ps.tkinter]);

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else if stdenv.isAarch32 then
  "ARM"
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

  # OpenSSL 1.1.1t
  vendoredOpenSSL = fetchFromGitHub {
    owner = "openssl";
    repo = "openssl";
    rev = "OpenSSL_1_1_1t";
    sha256 = "sha256-gI2+Vm67j1+xLvzBb+DF0YFTOHW7myotRsXRzluzSLY=";
  };

edk2 = buildStdenv.mkDerivation {
  pname = "edk2";
  version = "202211";

  patches = [
    # pass targetPrefix as an env var
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/edk2/raw/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/0021-Tweak-the-tools_def-to-support-cross-compiling.patch";
      sha256 = "sha256-E1/fiFNVx0aB1kOej2DJ2DlBIs9tAAcxoedym2Zhjxw=";
    })
    # Apply EDK2-specific OpenSSL 1.1.1t changes
    # Original bug: https://bugzilla.tianocore.org/show_bug.cgi?id=4342
    (fetchpatch {
      url = "https://bugzilla.tianocore.org/attachment.cgi?id=1330";
      hash = "sha256-HAwa9gqTxA5+8UQf5NiRdZYSmE6ykQsDbkHFj7oLygg=";
      # Normally, EDK2 vendors OpenSSL via Git submodules
      # We unbundle them because fetchpatch and fetchers interaction are not ideal in nixpkgs.
      # i.e. we cannot patch a git submodule at the right moment.
      excludes = [ "CryptoPkg/Library/OpensslLib/openssl" ];
    })
  ];

  src = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "edk2-stable${edk2.version}";
    fetchSubmodules = true;
    sha256 = "sha256-0jE73xPyenAcgJ1mS35oTc5cYw7jJvVYxhPdhTWpKA0=";
  };

  postUnpack = ''
    rm -rf source/CryptoPkg/Library/OpensslLib/openssl
  '';

  # Update the OpenSSL used APIs to 1.1.1t in EDK2…
  # OpenSSL3 PoC exist: https://patchew.org/EDK2/cover.1679026329.git.yi1.li@intel.com/
  # Unvendor only when OpenSSL3 support lands otherwise fix everything that breaks, I guess?
  postPatch = ''
    cp -r ${vendoredOpenSSL} CryptoPkg/Library/OpensslLib/openssl
  '';

  nativeBuildInputs = [ pythonEnv ];
  depsBuildBuild = [ buildPackages.stdenv.cc buildPackages.util-linux buildPackages.bash ];
  strictDeps = true;

  # trick taken from https://src.fedoraproject.org/rpms/edk2/blob/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/edk2.spec#_319
  ${"GCC5_${targetArch}_PREFIX"}=stdenv.cc.targetPrefix;

  makeFlags = [ "-C BaseTools" ]
    ++ lib.optionals (stdenv.cc.isClang) [ "CXX=llvm BUILD_AR=ar BUILD_CC=clang BUILD_CXX=clang++ BUILD_AS=clang BUILD_LD=ld" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-return-type" + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
    # patchShebangs fails to see these when cross compiling
    for i in $out/BaseTools/BinWrappers/PosixLike/*; do
      substituteInPlace $i --replace '/usr/bin/env bash' ${buildPackages.bash}/bin/bash
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/EDK-II/";
    license = licenses.bsd2;
    platforms = with platforms; aarch64 ++ arm ++ i686 ++ x86_64;
  };

  passthru = {
    mkDerivation = projectDscPath: attrsOrFun: buildStdenv.mkDerivation (finalAttrs:
    let
      attrs = lib.toFunction attrsOrFun finalAttrs;
    in
    {
      inherit (edk2) src;

      depsBuildBuild = [ buildPackages.stdenv.cc ] ++ attrs.depsBuildBuild or [];
      nativeBuildInputs = [ bc pythonEnv ] ++ attrs.nativeBuildInputs or [];
      strictDeps = true;

      ${"GCC5_${targetArch}_PREFIX"}=stdenv.cc.targetPrefix;

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
        build -a ${targetArch} -b ${attrs.buildConfig or "RELEASE"} -t ${buildType} -p ${projectDscPath} -n $NIX_BUILD_CORES $buildFlags
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mv -v Build/*/* $out
        runHook postInstall
      '';
    } // removeAttrs attrs [ "nativeBuildInputs" "depsBuildBuild" ]);
  };
};

in

edk2
