{ stdenv, fetchgit, libuuid, python2, iasl }:

let
  pythonEnv = python2.withPackages(ps: [ps.tkinter]);

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else
  throw "Unsupported architecture";

edk2 = stdenv.mkDerivation {
  name = "edk2-2014-12-10";

  src = fetchgit {
    url = git://github.com/tianocore/edk2;
    rev = "684a565a04";
    sha256 = "0s9ywb8w7xzlnmm4kwzykxkrdaw53b7pky121cc9wjkllzqwyxrb";
  };

  buildInputs = [ libuuid pythonEnv];

  makeFlags = "-C BaseTools";

  hardeningDisable = [ "format" "fortify" ];

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v EdkCompatibilityPkg $out
    mv -v edksetup.sh $out
  '';

  meta = {
    description = "Intel EFI development kit";
    homepage = https://sourceforge.net/projects/edk2/;
    license = stdenv.lib.licenses.bsd2;
    platforms = ["x86_64-linux" "i686-linux"];
  };

  passthru = {
    setup = projectDscPath: attrs: {
      buildInputs = [ pythonEnv ] ++
        stdenv.lib.optionals (attrs ? buildInputs) attrs.buildInputs;

      configurePhase = ''
        mkdir -v Conf
        sed -e 's|Nt32Pkg/Nt32Pkg.dsc|${projectDscPath}|' -e \
          's|MYTOOLS|GCC49|' -e 's|IA32|${targetArch}|' -e 's|DEBUG|RELEASE|'\
          < ${edk2}/BaseTools/Conf/target.template > Conf/target.txt
        sed -e 's|DEFINE GCC48_IA32_PREFIX       = /usr/bin/|DEFINE GCC48_IA32_PREFIX       = ""|' \
          -e 's|DEFINE GCC48_X64_PREFIX        = /usr/bin/|DEFINE GCC48_X64_PREFIX        = ""|' \
          -e 's|DEFINE UNIX_IASL_BIN           = /usr/bin/iasl|DEFINE UNIX_IASL_BIN           = ${iasl}/bin/iasl|' \
          < ${edk2}/BaseTools/Conf/tools_def.template > Conf/tools_def.txt
        export WORKSPACE="$PWD"
        export EFI_SOURCE="$PWD/EdkCompatibilityPkg"
        ln -sv ${edk2}/BaseTools BaseTools
        ln -sv ${edk2}/EdkCompatibilityPkg EdkCompatibilityPkg
        . ${edk2}/edksetup.sh BaseTools
      '';

      buildPhase = "
        build
      ";

      installPhase = "mv -v Build/*/* $out";
    } // (removeAttrs attrs [ "buildInputs" ] );
  };
};

in

edk2
