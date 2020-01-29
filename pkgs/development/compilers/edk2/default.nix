{ stdenv, fetchgit, fetchpatch, libuuid, python3, iasl, bc }:

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

edk2 = stdenv.mkDerivation {
  pname = "edk2";
  version = "201911";

  # submodules
  src = fetchgit {
    url = "https://github.com/tianocore/edk2";
    rev = "edk2-stable${edk2.version}";
    sha256 = "1rmvb4w043v25cppsqxqrpzqqcay3yrzsrhhzm2q9bncrj56vm8q";
  };

  buildInputs = [ libuuid pythonEnv ];

  makeFlags = [ "-C BaseTools" ];
  NIX_CFLAGS_COMPILE = "-Wno-return-type -Wno-error=stringop-truncation";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v edksetup.sh $out
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Intel EFI development kit";
    homepage = https://sourceforge.net/projects/edk2/;
    license = licenses.bsd2;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };

  passthru = {
    mkDerivation = projectDscPath: attrs: stdenv.mkDerivation ({
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
        build -a ${targetArch} -b RELEASE -t GCC5 -p ${projectDscPath} -n $NIX_BUILD_CORES $buildFlags
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
