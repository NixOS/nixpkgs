{ stdenv, fetchgit, libuuid, pythonFull, iasl }:

let

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else
  throw "Unsupported architecture";

edk2 = stdenv.mkDerivation {
  name = "edk2-2014-02-01";
  
  src = fetchgit {
    url = git://github.com/tianocore/edk2;
    rev = "2818c158de6a164d012e6afb0fc145656aed4e4b";
    sha256 = "a756b5de3a3e71d82ce1de8c7832bc69d2affb98d704894b26540571f9f5e214";
  };

  buildInputs = [ libuuid pythonFull ];

  buildPhase = ''
    make -C BaseTools
  '';

  installPhase = ''
    mkdir -vp $out
    mv -v BaseTools $out
    mv -v EdkCompatibilityPkg $out
    mv -v edksetup.sh $out
  '';

  meta = {
    description = "Intel EFI development kit";
    homepage = http://sourceforge.net/apps/mediawiki/tianocore/index.php?title=EDK2;
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };

  passthru = {
    setup = projectDscPath: attrs: {
      buildInputs = [ pythonFull ] ++
        stdenv.lib.optionals (attrs ? buildInputs) attrs.buildInputs;

      configurePhase = ''
        mkdir -v Conf
        sed -e 's|Nt32Pkg/Nt32Pkg.dsc|${projectDscPath}|' -e \
          's|MYTOOLS|GCC48|' -e 's|IA32|${targetArch}|' -e 's|DEBUG|RELEASE|'\
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
