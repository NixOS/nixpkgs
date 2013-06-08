{ stdenv, fetchsvn, libuuid, pythonFull, iasl }:

let

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else
  throw "Unsupported architecture";

edk2 = stdenv.mkDerivation {
  name = "edk2-2013-03-19";
  
  src = fetchsvn {
    url = https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2;
    rev = "14211";
    sha256 = "1rhrv7cyazb1d4gw3s8fv0c245iankvb9pqx6nngbkkxkcswvnw7";
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
          's|MYTOOLS|GCC46|' -e 's|IA32|${targetArch}|' -e 's|DEBUG|RELEASE|'\
          < ${edk2}/BaseTools/Conf/target.template > Conf/target.txt
        sed -e 's|DEFINE GCC46_IA32_PREFIX       = /usr/bin/|DEFINE GCC46_IA32_PREFIX       = ""|' \
          -e 's|DEFINE GCC46_X64_PREFIX        = /usr/bin/|DEFINE GCC46_X64_PREFIX        = ""|' \
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
