{ stdenv, bzip2, patchelf, glibc, gcc, fetchurl, version, releaseType, sha256, ncurses
, dirName ? null, subdirName ? null }:
with stdenv.lib;
let
  versionParts = splitString "-" version; # 4.7 2013q3 20130916
  majorVersion = elemAt versionParts 0; # 4.7
  yearQuarter = elemAt versionParts 1; # 2013q3
  underscoreVersion = replaceChars ["."] ["_"] version; # 4_7-2013q3-20130916
  yearQuarterParts = splitString "q" yearQuarter; # 2013 3
  year = elemAt yearQuarterParts 0; # 2013
  quarter = elemAt yearQuarterParts 1; # 3
  dirName_ = if dirName != null then dirName else majorVersion;
  subdirName_ = if subdirName != null then subdirName
    else "${majorVersion}-${year}-q${quarter}-${releaseType}"; # 4.7-2013-q3-update
in
stdenv.mkDerivation {
  name = "gcc-arm-embedded-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gcc-arm-embedded/${dirName_}/${subdirName_}/+download/gcc-arm-none-eabi-${underscoreVersion}-linux.tar.bz2";
    sha256 = sha256;
  };

  nativeBuildInputs = [ bzip2 patchelf ];

  dontPatchELF = true;

  phases = "unpackPhase patchPhase installPhase";

  installPhase = ''
    mkdir -pv $out
    cp -r ./* $out

    for f in $(find $out); do
      if [ -f "$f" ] && patchelf "$f" 2> /dev/null; then
        patchelf --set-interpreter ${getLib glibc}/lib/ld-linux.so.2 \
                 --set-rpath ${stdenv.lib.makeLibraryPath [ "$out" gcc ncurses ]} \
                 "$f" || true
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Pre-built GNU toolchain from ARM Cortex-M & Cortex-R processors (Cortex-M0/M0+/M3/M4, Cortex-R4/R5/R7)";
    homepage = https://launchpad.net/gcc-arm-embedded;
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = [ maintainers.rasendubi ];
    platforms = platforms.linux;
  };
}
