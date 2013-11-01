{ stdenv, fetchgit, libuuid, pythonFull, iasl }:

let

targetArch = if stdenv.isi686 then
  "IA32"
else if stdenv.isx86_64 then
  "X64"
else
  throw "Unsupported architecture";

edk2 = stdenv.mkDerivation {
  name = "edk2-2013-10-09";
  
  src = fetchgit {
    url = git://github.com/tianocore/edk2;
    rev = "5bcb62a4098c9bde9be6af0833a025adc768e08d";
    sha256 = "3e2958877061bf6bbfb28b150743d7244486929c1c320bdb1ff2586774aa042a";
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
