{ lib, stdenv, fetchFromGitHub, fetchurl, fetchzip
, autoconf, automake, autoreconfHook, clang, dos2unix, file, perl
, pkg-config
, alsa-lib, coreutils, freetype, glib, glibc, gnugrep, libpulseaudio, libtool
, libuuid, openssl, pango, xorg
, squeakImageHash ? null, squeakSourcesHash ? null, squeakSourcesVersion ? null
, squeakVersion ? null, squeakVmCommitHash ? null, squeakVmCommitHashHash ? null
, squeakVmVersion ? null
} @ args:

let
  inherit (builtins) elemAt;
  nullableOr = o: default: if o == null then default else o;

  bits = stdenv.hostPlatform.parsed.cpu.bits;

  squeakVersion = nullableOr args.squeakVersion or null "5.3-19459";
  squeakVersionSplit = builtins.split "-" squeakVersion;
  squeakVersionBase = elemAt squeakVersionSplit 0;
  squeakVersionBaseSplit = lib.splitVersion squeakVersionBase;
  squeakVersionMajor = elemAt squeakVersionBaseSplit 0;
  squeakVersionMinor = elemAt squeakVersionBaseSplit 1;

  squeakImageVersion = elemAt squeakVersionSplit 2;

  squeakSourcesVersion = nullableOr args.squeakSourcesVersion or null "50";

  squeakVmVersion = nullableOr args.squeakVmVersion or null "5.0-202003021730";
  squeakVmVersionSplit = builtins.split "-" squeakVmVersion;
  squeakVmVersionBase = elemAt squeakVmVersionSplit 0;
  squeakVmVersionBaseSplit = lib.splitVersion squeakVmVersionBase;
  squeakVmVersionMajor = elemAt squeakVmVersionBaseSplit 0;
  squeakVmVersionMinor = elemAt squeakVmVersionBaseSplit 1;
  squeakVmVersionRelease = elemAt squeakVmVersionSplit 2;

  squeakVmCommitHash = nullableOr args.squeakVmCommitHash or null (fetchurl {
    url = "https://api.github.com/repos/OpenSmalltalk/opensmalltalk-vm/commits/${squeakVmVersionRelease}";
    curlOpts = "--header Accept:application/vnd.github.v3.sha";
    hash = nullableOr args.squeakVmCommitHashHash or null
      "sha256-quwmhpJlb2fp0fI9b03fBxSR44j1xmHPW20wkSqTOhQ=";
  });
in stdenv.mkDerivation {
  pname = "squeak";
  version = squeakVersion;

  vmVersionRelease = squeakVmVersionRelease; # "202003021730"
  vmHash = squeakVmCommitHash;

  vmSrcUrl = "https://github.com/OpenSmalltalk/opensmalltalk-vm.git";
  src = fetchFromGitHub {
    owner = "OpenSmalltalk";
    repo = "opensmalltalk-vm";
    rev = squeakVmVersionRelease;
    hash = nullableOr args.squeakVmHash or null
      "sha256-rNJn5ya+7ggC21MpwSrl2ByJDjVycONKHADboH7dQLM=";
  };
  imageSrc = let
    squeakImageName = "Squeak${squeakVersionBase}-${squeakImageVersion}-${toString bits}bit";
  in fetchzip {
    url = "https://files.squeak.org/${squeakVersionBase}/${squeakImageName}/${squeakImageName}.zip";
    name = "source";
    stripRoot = false;
    hash = nullableOr args.squeakImageHash or null
      "sha256-wDuRyc/DNqG1D4DzyBkUvrzFkBlXBtbpnANZlRV/Fas=";
  };
  sourcesSrc = fetchurl {
    url = "https://files.squeak.org/sources_files/SqueakV${squeakSourcesVersion}.sources.gz";
    hash = nullableOr args.squeakSourcesHash or null
      "sha256-ZViZ1VgI32LwLTEyw7utp8oaAK3UmCNJnHqsGm1IKYE=";
  };

  vmBuild = "linux64x64";

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    clang
    dos2unix
    file
    perl
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    coreutils
    freetype
    glib
    glibc
    gnugrep
    libpulseaudio
    libtool
    libuuid
    openssl
    pango
    xorg.libX11
  ];

  postUnpack = ''
    for file in "$imageSrc"/*.{image,changes}; do
      gzip -c "$file" > "$sourceRoot/''${file##"$imageSrc"/}.gz"
    done
  '';

  prePatch = ''
    dos2unix platforms/unix/plugins/*/{Makefile.inc,acinclude.m4}
  '';

  patches = [
    ./squeak-configure-version.patch
    ./squeak-plugins-discovery.patch
    ./squeak-squeaksh-nixpkgs.patch
  ];

  postPatch = ''
    vmVersionDate=$(sed 's/\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)/\1-\2-\3T\4:\5+0000/' <<< "$vmVersionRelease")
    vmVersionDate=$(date -u '+%a %b %-d %T %Y %z' -d "$vmVersionDate")
    vmVersionFiles=$(sed -n 's/^versionfiles="\(.*\)"/\1/p' ./scripts/updateSCCSVersions)
    vmHash=$(< "$vmHash")
    vmAbbrevHash=''${vmHash:0:12}
    printf '%s\n' "$vmAbbrevHash"
    for vmVersionFile in $vmVersionFiles; do
      substituteInPlace "$vmVersionFile" \
        --replace "\$Date\$" "\$Date: ''${vmVersionDate} \$" \
        --replace "\$URL\$" "\$URL: ''${vmSrcUrl} \$" \
        --replace "\$Rev\$" "\$Rev: ''${vmVersionRelease} \$" \
        --replace "\$CommitHash\$" "\$CommitHash: ''${vmAbbrevHash} \$"
    done
    patchShebangs --build ./"build.$vmBuild"/squeak.cog.spur ./scripts
    for squeaksh in ./platforms/unix/config/{,bin.}squeak.sh.in; do
      substituteInPlace "$squeaksh" \
        --subst-var-by 'glibc' ${lib.escapeShellArg (lib.getBin glibc)} \
        --subst-var-by 'gnugrep' ${lib.escapeShellArg (lib.getBin gnugrep)}
    done
    substituteInPlace ./platforms/unix/config/mkmf \
      --replace '/bin/rm ' '${coreutils}/bin/rm '
  '';

  # Workaround build failure on -fno-common toolchains:
  #   ld: vm/vm.a(cogit.o):spur64src/vm/cogitX64SysV.c:2552: multiple definition of
  #       `traceStores'; vm/vm.a(gcc3x-cointerp.o):spur64src/vm/cogit.h:140: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  preAutoreconf = ''
    pushd ./platforms/unix/config > /dev/null
    ./mkacinc > ./acplugins.m4
  '';
  postAutoreconf = ''
    rm ./acplugins.m4
    popd > /dev/null
  '';

  preConfigure = ''
    if [ -z "''${dontFixLibtool:-}" ]; then
        local i
        find ./platforms/unix/config -iname "ltmain.sh" -print0 | while IFS=''' read -r -d ''' i; do
            echo "fixing libtool script $i"
            fixLibtool "$i"
        done
    fi

    substituteInPlace ./platforms/unix/config/configure \
      --replace "/usr/bin/file" "${file}/bin/file"
    cd ./"build.$vmBuild"/squeak.cog.spur/build
    substituteInPlace ./mvm \
      --replace 'read a' 'a=y' \
      --replace $'if [ $# -ge 1 ]; then\n\tINSTALLDIR="$1"; shift\nfi\n' "" \
      --replace 'config/configure' 'config/configure "$@"' \
      --replace 'make install' '# make install'
  '';

  configureFlags = [
    "--disable-dynamicopenssl"
    "SQ_MAJOR=${squeakVersionMajor}"
    "SQ_MINOR=${squeakVersionMinor}"
    "SQ_UPDATE=${squeakImageVersion}"
    "SQ_VERSION=${squeakVersion}-${toString bits}bit"
    "SQ_SRC_VERSION=${squeakSourcesVersion}"
    "VM_MAJOR=${squeakVmVersionMajor}"
    "VM_MINOR=${squeakVmVersionMinor}"
    "VM_RELEASE=${squeakVmVersionRelease}"
    "VM_VERSION=${squeakVmVersion}"
  ];
  configureScript = "./mvm";

  installTargets = [ "install" "install-image" ];

  postInstall = ''
    rm "$out/squeak"
    cp --no-preserve mode "$sourcesSrc" "$out"/lib/squeak/SqueakV${lib.escapeShellArg squeakSourcesVersion}.sources
  '';

  meta = with lib; {
    description = "Squeak virtual machine";
    homepage = "https://opensmalltalk.org/";
    license = with licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}
