{ stdenv, fetchsvn, libuuid, pythonFull, iasl }:

let

  targetArch = if stdenv.isi686 then
    "IA32"
  else if stdenv.isx86_64 then
    "X64"
  else
    throw "Unsupported architecture";

in

stdenv.mkDerivation {
  name = "edk2-2012-03-13";
  
  src = fetchsvn {
    url = https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2;
    rev = "13094";
    sha256 = "1qfpal0y4sas204ydg3pg3634dm25q1vr94mpgmbdh6yqcviah3h";
  };

  buildInputs = [ libuuid pythonFull ];

  buildPhase = ''
    make -C BaseTools
    build="$(pwd)"
    cd ..
    mv $build $out
    export EDK_TOOLS_PATH="$out"/BaseTools
    cd $out
    . edksetup.sh BaseTools
    sed -e 's|Nt32Pkg/Nt32Pkg.dsc|MdeModulePkg/MdeModulePkg.dsc|' -e \
      's|MYTOOLS|GCC46|' -e 's|IA32|${targetArch}|' -e 's|DEBUG|RELEASE|'\
      < $out/Conf/target.txt > target.txt.tmp
    mv target.txt.tmp $out/Conf/target.txt
    sed -e 's|DEFINE GCC46_IA32_PREFIX       = /usr/bin/|DEFINE GCC46_IA32_PREFIX       = ""|' \
      -e 's|DEFINE GCC46_X64_PREFIX        = /usr/bin/|DEFINE GCC46_X64_PREFIX        = ""|' \
      -e 's|DEFINE UNIX_IASL_BIN           = /usr/bin/iasl|DEFINE UNIX_IASL_BIN           = ${iasl}/bin/iasl|'  < $out/Conf/tools_def.txt > tools_def.txt.tmp
    mv tools_def.txt.tmp $out/Conf/tools_def.txt
    build
  '';

  installPhase = "true";

  meta = {
    description = "Intel EFI development kit";
    homepage = http://sourceforge.net/apps/mediawiki/tianocore/index.php?title=EDK2;
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
}
