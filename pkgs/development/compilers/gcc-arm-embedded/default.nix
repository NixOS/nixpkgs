{ stdenv, bzip2, patchelf, glibc, gcc, fetchurl, ncurses, binaries }:
with stdenv.lib;
let
  binaryPlatform = {
    i686-linux = "linux";
    x86_64-darwin = "mac";
  }.${stdenv.system};
  
  binary = binaries.${binaryPlatform};
  version = binary.version;
  releaseType = binary.releaseType;
  sha256 = binary.sha256;
  
  versionParts = splitString "-" version; # 4.7 2013q3 20130916
  majorVersion = elemAt versionParts 0; # 4.7
  yearQuarter = elemAt versionParts 1; # 2013q3
  underscoreVersion = replaceChars ["."] ["_"] version; # 4_7-2013q3-20130916
  yearQuarterParts = splitString "q" yearQuarter; # 2013 3
  year = elemAt yearQuarterParts 0; # 2013
  quarter = elemAt yearQuarterParts 1; # 3
  subdirName = "${majorVersion}-${year}-q${quarter}-${releaseType}"; # 4.7-2013-q3-update
in
stdenv.mkDerivation {
  name = "gcc-arm-embedded-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gcc-arm-embedded/${majorVersion}/${subdirName}/+download/gcc-arm-none-eabi-${underscoreVersion}-${binaryPlatform}.tar.bz2";
    sha256 = sha256;
  };

  buildInputs = [ bzip2 patchelf ];
 
  dontPatchELF = true;
  
  phases = "unpackPhase patchPhase installPhase";
  
  installPhase =
    ''
      mkdir -pv $out
      cp -r ./* $out
    '' +
    stdenv.lib.optionalString stdenv.isLinux ''
      for f in $(find $out); do
        if [ -f "$f" ] && patchelf "$f" 2> /dev/null; then
          patchelf --set-interpreter ${glibc}/lib/ld-linux.so.2 \
                  --set-rpath $out/lib:${gcc}/lib:${ncurses}/lib \
                  "$f" || true
        fi
      done
    '';

  meta = with stdenv.lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors (Cortex-M0/M0+/M3/M4, Cortex-R4/R5/R7)";
    homepage = "https://launchpad.net/gcc-arm-embedded";
    license = licenses.gpl3;
    platforms = ["i686-linux" "x86_64-darwin"];
  };
}
