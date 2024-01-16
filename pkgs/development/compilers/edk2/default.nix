{ stdenv
, clangStdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, runCommand
, libuuid
, python3
, bc
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
else if stdenv.hostPlatform.isRiscV64 then
  "RISCV64"
else
  throw "Unsupported architecture";

buildType = if stdenv.isDarwin then
    "CLANGPDB"
  else
    "GCC5";

edk2 = stdenv.mkDerivation rec {
  pname = "edk2";
  version = "202311";

  patches = [
    # pass targetPrefix as an env var
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/edk2/raw/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/0021-Tweak-the-tools_def-to-support-cross-compiling.patch";
      hash = "sha256-E1/fiFNVx0aB1kOej2DJ2DlBIs9tAAcxoedym2Zhjxw=";
    })
    (fetchurl { # Patch format does not play well with fetchpatch, it should be fine this is a static attachment in a ticket
      name = "CVE-2023-45229_CVE-2023-45230_CVE-2023-45231_CVE-2023-45232_CVE-2023-45233_CVE-2023-45234_CVE-2023-45235.patch";
      url = "https://bugzilla.tianocore.org/attachment.cgi?id=1457";
      hash = "sha256-CF41lbjnXbq/6DxMW6q1qcLJ8WAs+U0Rjci+jRwJYYY=";
    })
    (fetchpatch {
      name = "CVE-2022-36764.patch";
      url = "https://bugzilla.tianocore.org/attachment.cgi?id=1436";
      hash = "sha256-czku8DgElisDv6minI67nNt6BS+vH6txslZdqiGaQR4=";
      excludes = [
        "SecurityPkg/Test/SecurityPkgHostTest.dsc"
      ];
    })
  ];

  srcWithVendoring = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "edk2-stable${edk2.version}";
    fetchSubmodules = true;
    hash = "sha256-gC/If8U9qo70rGvNl3ld/mmZszwY0w/5Ge/K21mhzYw=";
  };

  # We don't want EDK2 to keep track of OpenSSL,
  # they're frankly bad at it.
  src = runCommand "edk2-unvendored-src" { } ''
    cp --no-preserve=mode -r ${srcWithVendoring} $out
    rm -rf $out/CryptoPkg/Library/OpensslLib/openssl
    mkdir -p $out/CryptoPkg/Library/OpensslLib/openssl
    tar --strip-components=1 -xf ${buildPackages.openssl.src} -C $out/CryptoPkg/Library/OpensslLib/openssl
    chmod -R +w $out/
  '';

  nativeBuildInputs = [ pythonEnv ];
  depsBuildBuild = [ buildPackages.stdenv.cc buildPackages.bash ];
  depsHostHost = [ libuuid ];
  strictDeps = true;

  # trick taken from https://src.fedoraproject.org/rpms/edk2/blob/08f2354cd280b4ce5a7888aa85cf520e042955c3/f/edk2.spec#_319
  ${"GCC5_${targetArch}_PREFIX"} = stdenv.cc.targetPrefix;

  makeFlags = [ "-C BaseTools" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-return-type"
    + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation"
    + lib.optionalString (stdenv.isDarwin) " -Wno-error=macro-redefined";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
    # patchShebangs fails to see these when cross compiling
    for i in $out/BaseTools/BinWrappers/PosixLike/*; do
      substituteInPlace $i --replace '/usr/bin/env bash' ${buildPackages.bash}/bin/bash
      chmod +x "$i"
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel EFI development kit";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/EDK-II/";
    license = licenses.bsd2;
    platforms = with platforms; aarch64 ++ arm ++ i686 ++ x86_64 ++ riscv64;
  };

  passthru = {
    mkDerivation = projectDscPath: attrsOrFun: stdenv.mkDerivation (finalAttrs:
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
