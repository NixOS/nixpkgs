{
  lib,
  clangStdenv,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  autoconf,
  automake,
  autoreconfHook,
  dos2unix,
  file,
  perl,
  pkg-config,
  alsa-lib,
  coreutils,
  freetype,
  glib,
  glibc,
  gnugrep,
  libGL,
  libpulseaudio,
  libtool,
  libuuid,
  openssl,
  pango,
  libx11,
  squeakImageHash ? null,
  squeakSourcesHash ? null,
  squeakSourcesVersion ? null,
  squeakVersion ? null,
  squeakVmCommitHash ? null,
  squeakVmCommitHashHash ? null,
  squeakVmHash ? null,
  squeakVmVersion ? null,
}@args:
let
  nullableOr = o: default: if o == null then default else o;
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "squeak";
  version = finalAttrs.squeakVersion;

  bits = clangStdenv.hostPlatform.parsed.cpu.bits;

  squeakVersion = nullableOr (args.squeakVersion or null) "5.3-19459";
  squeakVersionSplit = builtins.split "-" finalAttrs.squeakVersion;
  squeakVersionBase = builtins.elemAt finalAttrs.squeakVersionSplit 0;
  squeakVersionBaseSplit = lib.splitVersion finalAttrs.squeakVersionBase;
  squeakVersionMajor = builtins.elemAt finalAttrs.squeakVersionBaseSplit 0;
  squeakVersionMinor = builtins.elemAt finalAttrs.squeakVersionBaseSplit 1;

  squeakImageVersion = builtins.elemAt finalAttrs.squeakVersionSplit 2;

  squeakSourcesVersion = nullableOr (args.squeakSourcesVersion or null) "50";

  squeakVmVersion = nullableOr (args.squeakVmVersion or null) "5.0-202003021730";
  squeakVmVersionSplit = builtins.split "-" finalAttrs.squeakVmVersion;
  squeakVmVersionBase = builtins.elemAt finalAttrs.squeakVmVersionSplit 0;
  squeakVmVersionBaseSplit = lib.splitVersion finalAttrs.squeakVmVersionBase;
  squeakVmVersionMajor = builtins.elemAt finalAttrs.squeakVmVersionBaseSplit 0;
  squeakVmVersionMinor = builtins.elemAt finalAttrs.squeakVmVersionBaseSplit 1;
  squeakVmVersionRelease = builtins.elemAt finalAttrs.squeakVmVersionSplit 2;

  squeakVmCommitHash = nullableOr (args.squeakVmCommitHash or null) (fetchurl {
    url = "https://api.github.com/repos/OpenSmalltalk/opensmalltalk-vm/commits/${finalAttrs.squeakVmVersionRelease}";
    curlOpts = "--header Accept:application/vnd.github.v3.sha";
    hash = nullableOr (args.squeakVmCommitHashHash or null
    ) "sha256-quwmhpJlb2fp0fI9b03fBxSR44j1xmHPW20wkSqTOhQ=";
  });

  vmVersionRelease = finalAttrs.squeakVmVersionRelease; # "202003021730"
  vmHash = finalAttrs.squeakVmCommitHash;

  vmSrcUrl = "https://github.com/OpenSmalltalk/opensmalltalk-vm.git";
  src = fetchFromGitHub {
    owner = "OpenSmalltalk";
    repo = "opensmalltalk-vm";
    rev = finalAttrs.squeakVmVersionRelease;
    hash = nullableOr (args.squeakVmHash or null) "sha256-rNJn5ya+7ggC21MpwSrl2ByJDjVycONKHADboH7dQLM=";
  };
  imageSrc =
    let
      squeakImageName = "Squeak${finalAttrs.squeakVersionBase}-${finalAttrs.squeakImageVersion}-${toString finalAttrs.bits}bit";
    in
    fetchzip {
      url = "https://files.squeak.org/${finalAttrs.squeakVersionBase}/${squeakImageName}/${squeakImageName}.zip";
      name = "source";
      stripRoot = false;
      hash = nullableOr (args.squeakImageHash or null
      ) "sha256-wDuRyc/DNqG1D4DzyBkUvrzFkBlXBtbpnANZlRV/Fas=";
    };
  sourcesSrc = fetchurl {
    url = "https://files.squeak.org/sources_files/SqueakV${finalAttrs.squeakSourcesVersion}.sources.gz";
    hash = nullableOr (args.squeakSourcesHash or null
    ) "sha256-ZViZ1VgI32LwLTEyw7utp8oaAK3UmCNJnHqsGm1IKYE=";
  };

  vmBuild = "linux64x64";

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
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
    libGL
    libpulseaudio
    libtool
    libuuid
    openssl
    pango
    libx11
  ];

  postUnpack = ''
    for file in "${finalAttrs.imageSrc}"/*.{image,changes}; do
      gzip -c "$file" > "$sourceRoot/''${file##"${finalAttrs.imageSrc}"/}.gz"
    done
  '';

  prePatch = ''
    dos2unix platforms/unix/plugins/*/{Makefile.inc,acinclude.m4}
  '';

  patches = [
    ./squeak-configure-version.patch
    ./squeak-plugins-discovery.patch
    ./squeak-squeaksh-nixpkgs.patch
    # it looks like -export-dynamic is being passed erroneously to the compiler,
    # as it is a linker flag and at this step the build is just compiling notice the -c flag.
    ./cc-no-export-dynamic.patch
  ];

  postPatch = ''
    vmVersionDate=$(sed 's/\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)/\1-\2-\3T\4:\5+0000/' <<< "${finalAttrs.vmVersionRelease}")
    vmVersionDate=$(date -u '+%a %b %-d %T %Y %z' -d "$vmVersionDate")
    vmVersionFiles=$(sed -n 's/^versionfiles="\(.*\)"/\1/p' ./scripts/updateSCCSVersions)
    vmHash=$(< "${finalAttrs.vmHash}")
    vmAbbrevHash=''${vmHash:0:12}
    printf '%s\n' "$vmAbbrevHash"
    for vmVersionFile in $vmVersionFiles; do
      substituteInPlace "$vmVersionFile" \
        --replace "\$Date\$" "\$Date: ''${vmVersionDate} \$" \
        --replace "\$URL\$" "\$URL: ${finalAttrs.vmSrcUrl} \$" \
        --replace "\$Rev\$" "\$Rev: ${finalAttrs.vmVersionRelease} \$" \
        --replace "\$CommitHash\$" "\$CommitHash: ''${vmAbbrevHash} \$"
    done
    patchShebangs --build ./"build.${finalAttrs.vmBuild}"/squeak.cog.spur ./scripts
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
  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-fcommon"
      # C23 default rejects implicit declarations (e.g. close() without <unistd.h>).
      "-std=gnu17"
    ]
    ++ (lib.optionals clangStdenv.cc.isClang [
      # LLVM 16 turned these into errors (rightly, perhaps.)
      # Allow this package to continue to build despite this change.
      "-Wno-error=int-conversion"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-function-pointer-types"
    ])
  );

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
    cd ./"build.${finalAttrs.vmBuild}"/squeak.cog.spur/build
    substituteInPlace ./mvm \
      --replace 'read a' 'a=y' \
      --replace $'if [ $# -ge 1 ]; then\n\tINSTALLDIR="$1"; shift\nfi\n' "" \
      --replace 'config/configure' 'config/configure "$@"' \
      --replace 'make install' '# make install'
  '';

  configureFlags = [
    "--disable-dynamicopenssl"
    "SQ_MAJOR=${finalAttrs.squeakVersionMajor}"
    "SQ_MINOR=${finalAttrs.squeakVersionMinor}"
    "SQ_UPDATE=${finalAttrs.squeakImageVersion}"
    "SQ_VERSION=${finalAttrs.squeakVersion}-${toString finalAttrs.bits}bit"
    "SQ_SRC_VERSION=${finalAttrs.squeakSourcesVersion}"
    "VM_MAJOR=${finalAttrs.squeakVmVersionMajor}"
    "VM_MINOR=${finalAttrs.squeakVmVersionMinor}"
    "VM_RELEASE=${finalAttrs.squeakVmVersionRelease}"
    "VM_VERSION=${finalAttrs.squeakVmVersion}"
  ];
  configureScript = "./mvm";

  installTargets = [
    "install"
    "install-image"
  ];

  postInstall = ''
    rm "$out/squeak"
    cp --no-preserve mode "${finalAttrs.sourcesSrc}" "$out"/lib/squeak/SqueakV${lib.escapeShellArg finalAttrs.squeakSourcesVersion}.sources
  '';

  meta = {
    description = "Squeak virtual machine";
    homepage = "https://opensmalltalk.org/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = [ "x86_64-linux" ];
  };
})
